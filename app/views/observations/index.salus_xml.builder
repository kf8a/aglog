xml = Builder::XmlMarkup.new(:indent => 2)
xml.instruct!

observations = Observation.find(:all, :include=>[:areas,:activities], :order=>'obs_date desc')
xml.observations do
  observations.each do |observation|
    xml.observation do
      xml.date observation.obs_date.to_s
      xml.comment observation.comment
      xml.areas do
        observation.areas.each do |area|
          xml.area area.name
        end
      end
      xml.observation_types do
        observation.observation_types.each do |type|
          xml.observation_type type.name
        end
      end
      xml.activities do
        observation.activities.each do |activity|
          xml.setups do
            activity.setups.each do |setup|
              xml.transactions do
                setup.material_transactions.each do |transaction|
                  xml.transaction do
                    xml.material transaction.material.name if transaction.material
                    xml.rate transaction.rate
                    xml.n_content transaction.material.n_content if transaction.material
                    xml.unit transaction.unit.name if transaction.unit
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end