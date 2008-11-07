require 'will_paginate'
require 'finder'

ActiveRecord::Base.send     :include, WillPaginate::Finder
ActionController::Base.send :include, WillPaginate::ControllerHelpers
ActionView::Base.send       :include, WillPaginate::ViewHelpers
