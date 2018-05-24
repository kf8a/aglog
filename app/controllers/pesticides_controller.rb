# frozen_string_literal: true

# Returns the list of fields that have had pesticides applied
class PesticidesController < ApplicationController
  def index
    @closed_fields = ObservationType.find(5)
                                    .observations.where(company_id: 1)
                                    .order('obs_date')
                                    .collect do |record|
      reentry_date = record.obs_date + 30.days
      next unless reentry_date > Date.today
      { date: reentry_date, areas: record.areas_as_text }
    end.compact

    render :index
  end
end
