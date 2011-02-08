require 'spec_helper'

describe MaterialTransactionsController do
  render_views

  describe "Not signed in. " do
    before(:each) do
      sign_out
    end

    describe "POST :create" do
      before(:each) do
        @material = find_or_factory(:material)
        @old_count = @material.material_transactions.count
        post :create, :material_transaction => { :material_id => @material.id }
      end

      it "should not create a material transaction" do
        new_count = @material.material_transactions.count
        new_count.should equal @old_count
      end
    end

    describe "A material transaction exists. " do
      before(:each) do
        @transaction = Factory.create(:material_transaction)
      end

      describe "PUT :update the transaction" do
        before(:each) do
          @new_setup = Factory.create(:setup)
          put :update, :id => @transaction.id, :material_transaction => { :setup_id => @new_setup.id }
        end

        it "should not update the transaction" do
          assert_nil MaterialTransaction.find_by_setup_id(@new_setup.id)
        end
      end

      describe "DELETE :destroy the transaction" do
        before(:each) do
          delete :destroy, :id => @transaction.id
        end

        it "should not delete the transaction" do
          assert MaterialTransaction.find_by_id(@transaction.id)
        end
      end
    end
  end

  describe "Signed in as a normal user. " do
    before(:each) do
      sign_in_as_normal_user
    end

    describe "POST :create" do
      before(:each) do
        @material = find_or_factory(:material)
        @old_count = @material.material_transactions.count
        post :create, :material_transaction => { :material_id => @material.id }
      end

      it "should create a material transaction" do
        new_count = @material.material_transactions.count
        new_count.should equal (@old_count + 1)
      end
    end

    describe "POST :create with a setup" do
      before(:each) do
        @setup = find_or_factory(:setup)
        @material = find_or_factory(:material)
        @old_count = MaterialTransaction.where(:setup_id => @setup.id, :material_id => @material.id).count
        post :create, :material_transaction => { :setup_id => @setup.id, :material_id => @material.id }
      end

      it "should create a material transaction for that setup" do
        new_count = MaterialTransaction.where(:setup_id => @setup.id, :material_id => @material.id).count
        new_count.should equal (@old_count + 1)
      end
    end

    describe "PUT :update the transaction" do
      before(:each) do
        @transaction = Factory.create(:material_transaction)
        @new_setup = Factory.create(:setup)
        put :update, :id => @transaction.id, :material_transaction => { :setup_id => @new_setup.id }
      end

      it "should update the transaction" do
        assert MaterialTransaction.find_by_setup_id(@new_setup.id)
      end
    end

    describe "DELETE :destroy a material transaction" do
      before(:each) do
        @transaction = Factory.create(:material_transaction)
        delete :destroy, :id => @transaction.id
      end

      it "should delete the transaction" do
        assert_nil MaterialTransaction.find_by_id(@transaction.id)
      end
    end
  end
end

