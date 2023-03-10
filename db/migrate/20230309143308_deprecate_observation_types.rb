# frozen_string_literal: true

class DeprecateObservationTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :observation_types, :deprecated, :boolean, default: false
    add_column :observation_types, :order, :integer, unique: true
  end
end
