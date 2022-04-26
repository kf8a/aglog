# frozen_string_literal: true

# Worker Protection Standard helpers
class Wps
  def self.closed_fields
    # 5 is the pesticide observation type 'obs_date'
    # 13 is a herbicde application
    pesticde = ObservationType.find(5).observations.where(company_id: 1)
      .where('obs_date > ?', Time.zone.today - 30.days)
      .order('obs_date')
      .collect { |record| records(record) }.flatten

    herbicde = ObservationType.find(13).observations.where(company_id: 1)
      .where('obs_date > ?', Time.zone.today - 30.days)
      .order('obs_date')
      .collect { |record| records(record) }.flatten
    [pesticde, herbicde].flatten.uniq
  end

  def self.records(record)
    reentry_date = record.obs_date + 30.days
    Area.unparse(record.areas).split(/ /).map do |area|
      study = Area.parse(area).first.study
      { date: reentry_date, area: area, study: study.description, url: study.url }
    end
  end
end
