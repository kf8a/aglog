require 'spec_helper'

describe MaterialTransactionsController do
  render_views

  let(:material_transaction) { FactoryGirl.build_stubbed(:material_transaction) }
  let(:material)             { FactoryGirl.build_stubbed(:material) }

  before :each do
    material_transaction.stub(:save).and_return(true)
    MaterialTransaction.stub(:persisted?).and_return(true)
    MaterialTransaction.stub(:find).with(material_transaction.id.to_s).and_return(material_transaction)
    MaterialTransaction.stub(:by_company).and_return(MaterialTransaction)
  end

  describe "Not signed in. " do

    it 'does not allow POST :create' do
        post :create, :material_transaction => { :material_id => material }
        expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow PUT :update' do
      put :update, :id => material_transaction, :material_transaction => { :material_id => material}
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow DESTROY' do
      delete :destroy, :id => material_transaction
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "Signed in as a normal user. " do
    before(:each) do
      sign_in_as_normal_user
    end

    describe "POST :create" do
      before(:each) do
        post :create, :material_transaction => { :material_id => material }
      end

      it "should create a material transaction" do
        expect(MaterialTransaction.exists?(assigns[:transaction])).to be_true
      end
    end

    describe "POST :create with a setup" do
      context 'with valid attributes' do
        before(:each) do
          post :create, :material_transaction => { :setup_id => 1, :material_id => material }
        end

        it 'creates a new material_transaction' do
          expect(MaterialTransaction.exists?(assigns[:transaction])).to be_true
        end
      end

      context "with invalid attributes" do
        before(:each) do
          post :create, :material_transaction => { :setup_id => 1 }
        end

        it 'creates a new material_transaction' do
          expect(MaterialTransaction.exists?(assigns[:transaction])).to be_false
        end
      end
    end

    describe "PUT :update the transaction" do

      context 'valid attributes' do
        it "locates the reqested material_transaction" do
          material_transaction.should_receive(:update_attributes).with({"setup_id" => "1"}).and_return(true)
          put :update, :id => material_transaction, :material_transaction => { :setup_id => 1}
          expect(assigns[:transaction]).to eq material_transaction
        end
      end
      context 'invalid attributes' do
        before(:each) do
          material_transaction.should_receive(:update_attributes).and_return(false)
          put :update, :id => material_transaction, :material_transaction => { :setup_id => 1}
        end
        it 'should locate the requested material_transaction' do
          expect(assigns[:transaction]).to eq material_transaction
        end

        it 'should not update the material_transaction' do
          expect(assigns[:transaction]).to_not be_valid
        end
      end
    end

    describe "DELETE :destroy a material transaction" do
      before(:each) do
        material_transaction.stub(:destroy).and_return(true)
        delete :destroy, :id => material_transaction
      end

      it "should delete the transaction" do
        expect(MaterialTransaction.exists?(material_transaction)).to be_false
      end
    end
  end
end

