# frozen_string_literal: true

# Retrieve a list of closed fields
class Pesticide
  def self.closed_fields
    ObservationType.find(5)
                   .observations.where(company_id: 1)
                   .where('obs_date > ?', Date.today - 30.days)
                   .order('obs_date')
                   .collect do |record|
      reentry_date = record.obs_date + 30.days
      { date: reentry_date, areas: record.areas_as_text }
    end
  end
end
