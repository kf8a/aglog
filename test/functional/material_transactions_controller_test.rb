require 'test_helper'

class MaterialTransactionsControllerTest < ActionController::TestCase

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context "GET :new" do
      setup do
        get :new
      end

      should render_template 'new'
    end

    context "GET :new with a setup" do
      setup do
        @setup = Factory.create(:setup)
        get :new, :setup_id => @setup.id
      end

      should render_template 'new'
      should "make a material transaction that is part of that setup" do
        assert_equal @setup, assigns(:transaction).setup
      end
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
  end

end
