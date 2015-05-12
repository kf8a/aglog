class SalusController < ApplicationController
  respond_to :xml, :html

  def index
    @areas= Area.roots

    respond_with @areas
  end

  def show
    area = Area.find(params[:id])
    @salus = Salus.new
    @salus.area = area
  end
end
