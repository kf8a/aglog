# frozen_string_literal: true

#  Worker protection standard
#  Fields that are closed to untrained people
class WpsController < ApplicationController
  def index
    @closed_fields = Wps.closed_fields

    render :index
  end
end
