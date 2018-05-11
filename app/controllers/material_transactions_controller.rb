# These methods are most commonly called from the Edit Observation page to
# modify material transactions of an observation
class MaterialTransactionsController < ApplicationController
  def create
    @transaction = MaterialTransaction.new(material_transaction_params)
    @transaction.save
    head :ok
  end

  def update
    @transaction = MaterialTransaction.find(params[:id])
    if @transaction.update_attributes(material_transaction_params)
      flash[:activity] = 'Material Transaction was successfully updated.'
    end
    head :ok
  end

  def destroy
    @transaction = MaterialTransaction.find(params[:id])
    @transaction.destroy
    head :ok
  end

  private

  def material_transaction_params
    params.require(:material_transaction).permit(:material_id, :unit_id,
                                                 :setup_id, :rate, :cents,
                                                 :material_transaction_type_id,
                                                 :transaction_datetime)
  end
end
