# These methods are most commonly called from the Edit Observation page to modify
# material transactions of an observation
class MaterialTransactionsController < ApplicationController

  def create
    @transaction = MaterialTransaction.new(params[:material_transaction])
    @transaction.save
    render :nothing => true
  end

  def update
    @transaction = MaterialTransaction.find(params[:id])
    if @transaction.update_attributes(params[:material_transaction])
      flash[:activity] = "Material Transaction was successfully updated."
    end
    render :nothing => true
  end

  def destroy
    @transaction = MaterialTransaction.find(params[:id])
    @transaction.destroy
    render :nothing => true
  end
end
