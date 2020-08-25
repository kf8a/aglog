# frozen_string_literal: true

# Worker Protection Standard helpers
class Wps
  def self.closed_fields
    ObservationType.find(5).observations.where(company_id: 1).where('obs_date > ?', Date.today - 30.days).order( # 5 is the pesticide observation type
      'obs_date'
    ).collect { |record| records(record) }.flatten
  end

  def self.records(record)
    reentry_date = record.obs_date + 30.days
    Area.unparse(record.areas).split(/ /).map do |area|
      study = Area.parse(area).first.study
      { date: reentry_date, area: area, study: study.description, url: study.url }
    end
  end
end
