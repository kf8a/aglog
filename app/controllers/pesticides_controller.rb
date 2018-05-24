# frozen_string_literal: true

# Returns the list of fields that have had pesticides applied
class PesticidesController < ApplicationController
  def index
    @closed_fields = Pesticide.closed_fields

    render :index
  end
end
