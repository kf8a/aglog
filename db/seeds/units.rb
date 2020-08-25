# frozen_string_literal: true

Unit.find_or_create_by(name: 'gram')
Unit.find_or_create_by(name: 'kilogram', si_unit_id: 1, conversion_factor: 1000)
Unit.find_or_create_by(name: 'bushel')
Unit.find_or_create_by(name: 'metric ton')
Unit.find_or_create_by(name: 'fluid ounce')
Unit.find_or_create_by(name: 'ounce')
Unit.find_or_create_by(name: 'quart')
