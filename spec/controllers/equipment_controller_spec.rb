require 'spec_helper'

describe EquipmentController, type: :controller  do
  render_views

  describe 'Not signed in. ' do
    before do
      @equipment = FactoryGirl.create(:equipment, :name=>'tractor')
    end

    it 'renders the index' do
      get :index
      expect(response).to render_template 'index'
    end

    it 'does not allow new' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow create' do
      post :create, :equipment => { :name => 'Controller Creation', equipment_pictures: [] }
      expect(response).to redirect_to new_user_session_path
    end

    it 'shows equipment' do
      get :show, :id => @equipment.id
      expect(response).to render_template 'show'
    end

    it 'does now allow edit' do
      get :edit, :id => @equipment.id
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow updates' do
      put :update, :id => @equipment.id, :area => { :name => 'new_equipment'}
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow deletes' do
      delete :destroy, :id => @equipment.id
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "Signed in as a normal user. " do
    before(:all) do
      company_2 = FactoryGirl.create(:company, :name => 'glbrc')

      @equipment_2 = FactoryGirl.create(:equipment, :name=>'glbrc_tractor',
                                    :company => company_2)
    end

    before(:each) do
      sign_in_as_normal_user

      @company_1 = @user.company
      @equipment_1 = find_or_factory(:equipment, :name =>'lter_tractor',
                                     :company_id => @company_1.id)
    end

    after(:all) do
      @company = nil
      @equipment_1 = nil
      @equipment_2 = nil
    end

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it { should render_template 'index' }

      it 'should only show equipment for the company of the current user' do
        assert assigns(:equipment).include?(@equipment_1)
      end

      it 'should not show the other companies equipment' do
        assert !assigns(:equipment).include?(@equipment_2)
      end
    end

    it 'allows new' do
      get :new
      expect(response).to render_template 'new'
    end

    describe "POST :create" do
      it 'should create an equipment' do
        expect(Equipment).to receive(:new).with("name" => "Controller Creation").and_call_original
        post :create, :equipment => { :name => 'Controller Creation' }
      end

      it 'redirects to the new equipment' do
        post :create, :equipment => { :name => 'Controller Creation' }
        expect(response).to redirect_to equipment_path(assigns(:equipment))
      end

      it 'assigns the current users company id' do
        allow_any_instance_of(Equipment).to receive(:company=).with(controller.current_user.company)
        post :create, :equipment => { :name => 'Controller Creation' }
      end

      # it { should set_flash }
    end

    describe "POST :create with invalid attributes" do
      before(:each) do
        post :create, :equipment => { :name => "lter_tractor" } # Repeated name
      end

      it { is_expected.to render_template 'new' }
      it { is_expected.to_not set_flash }
    end

    describe "An equipment exists. " do
      before(:each) do
        @equipment = find_or_factory(:equipment, :company_id => @user.company.id)
      end

      describe "GET :show the equipment" do
        before(:each) do
          get :show, :id => @equipment
        end

        it { is_expected.to render_template 'show' }
      end

      describe "GET :edit the equipment" do
        before(:each) do
          get :edit, :id => @equipment
        end

        it { is_expected.to render_template 'edit' }
      end

      describe "PUT :update the equipment with valid attributes" do
        before(:each) do
          put :update, :id => @equipment, :equipment => { :name => 'New Name'}
        end

        it { is_expected.to redirect_to equipment_path(@equipment) }
        it 'should change the equipment' do
          @equipment.reload
          expect(@equipment.name).to eql('New Name')
        end
      end

      describe "PUT :update the equipment with invalid attributes" do
        before(:each) do
          find_or_factory(:equipment, :name => "Repeat_name",
                          :company_id=>@user.company.id)
          put :update, :id => @equipment, :equipment => { :name => "Repeat_name"}
        end

        it { is_expected.to render_template :edit }
      end

      describe "DELETE :destroy the equipment" do
        before(:each) do
          delete :destroy, :id => @equipment
        end

        it { is_expected.to redirect_to equipment_index_path }
        it "should destroy the equipment" do
          expect(Equipment.exists?(@equipment.id)).to eq false
        end
      end
    end
  end
end
