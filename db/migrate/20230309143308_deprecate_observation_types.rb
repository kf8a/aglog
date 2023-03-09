# frozen_string_literal: true

class DeprecateObservationTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :observation_types, :deprecated, :boolean, default: false
  end
end
