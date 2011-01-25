require 'test_helper'

class MaterialTransactionsControllerTest < ActionController::TestCase

  context "Not signed in. " do
    setup do
      sign_out
    end

    context "POST :create" do
      setup do
        @material = Factory.create(:material)
        post :create, :material_transaction => { :material_id => @material.id }
      end

      should "not create a material transaction" do
        assert_nil MaterialTransaction.find_by_material_id(@material.id)
      end
    end

    context "A material transaction exists. " do
      setup do
        @transaction = Factory.create(:material_transaction)
      end

      context "PUT :update the transaction" do
        setup do
          @new_setup = Factory.create(:setup)
          put :update, :id => @transaction.id, :material_transaction => { :setup_id => @new_setup.id }
        end

        should "not update the transaction" do
          assert_nil MaterialTransaction.find_by_setup_id(@new_setup.id)
        end
      end

      context "DELETE :destroy the transaction" do
        setup do
          delete :destroy, :id => @transaction.id
        end

        should "not delete the transaction" do
          assert MaterialTransaction.find_by_id(@transaction.id)
        end
      end
    end
  end

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
        assert MaterialTransaction.find_by_material_id(@material.id)
      end
    end

    context "POST :create with a setup" do
      setup do
        @setup = Factory.create(:setup)
        @material = Factory.create(:material)
        post :create, :material_transaction => { :setup_id => @setup.id, :material_id => @material.id }
      end

      should "create a material transaction for that setup" do
        assert MaterialTransaction.find_by_setup_id_and_material_id(@setup.id, @material.id)
      end
    end

    context "PUT :update the transaction" do
      setup do
        @transaction = Factory.create(:material_transaction)
        @new_setup = Factory.create(:setup)
        put :update, :id => @transaction.id, :material_transaction => { :setup_id => @new_setup.id }
      end

      should "update the transaction" do
        assert MaterialTransaction.find_by_setup_id(@new_setup.id)
      end
    end

    context "DELETE :destroy a material transaction" do
      setup do
        @transaction = Factory.create(:material_transaction)
        delete :destroy, :id => @transaction.id
      end

      should "delete the transaction" do
        assert_nil MaterialTransaction.find_by_id(@transaction.id)
      end
    end
  end

end
