require 'test_helper'

class MaterialTransactionsControllerTest < ActionController::TestCase

  #Write tests for non-signed-in-user

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "POST :create" do
      setup do
        @material = Factory.create(:material)
        post :create, :material_transaction => { :material_id => @material.id }
      end

      should "create a material transaction" do
        refute_nil MaterialTransaction.find_by_material_id(@material.id)
      end
    end

    context "POST :create with a setup" do
      setup do
        @setup = Factory.create(:setup)
        @material = Factory.create(:material)
        post :create, :material_transaction => { :setup_id => @setup.id, :material_id => @material.id }
      end

      should "create a material transaction for that setup" do
        refute_nil MaterialTransaction.find_by_setup_id_and_material_id(@setup.id, @material.id)
      end
    end

    context "DELETE :destroy a material transaction" do
      setup do
        @transaction = Factory.create(:material_transaction)
        delete :destroy, :id => @transaction.id
      end

      should "delete the setup" do
        assert_nil MaterialTransaction.find_by_id(@transaction.id)
      end
    end

    #TODO Write tests for PUT :update
  end

end
