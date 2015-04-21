class SalusController < ApplicationController
  respond_to :xml

  def show
    area = Area.find(params[:id])
    @salus = Salus.new
    @salus.area = area
  end
end
