# frozen_string_literal: true

# Allows modification and viewing of observations
class ObservationTypesController < ApplicationController
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  respond_to :json

  def index
    @observation_types = ObservationType.where(deprecated: false).all
    respond_with @observation_types
  end
end
