class MaterialTransactionsController < ApplicationController

  def new
    @setup = Setup.find_by_id(params[:setup_id])
    @transaction = if @setup then @setup.material_transactions.new else MaterialTransaction.new end
  end

  def create
    @transaction = MaterialTransaction.new(params[:material_transaction])
    @transaction.save
    render :nothing => true
  end

  #This is most commonly called from the Edit Observation page
  def destroy
    @transaction = MaterialTransaction.find(params[:id])
    @transaction.destroy
    render :nothing => true
  end
end
