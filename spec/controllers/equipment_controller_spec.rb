require 'spec_helper'

describe EquipmentController do
  render_views
  
  describe 'Not signed in. ' do
    before(:each) do
      sign_out
    end

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it { should render_template 'unauthorized_index' }
      it { should assign_to :equipment }
    end

    describe 'GET :new' do
      before(:each) do
        get :new
      end

      it { should redirect_to new_person_session_path }
    end

    describe 'POST :create' do
      before(:each) do
        Equipment.exists?(:name => 'Controller Creation').should be_false
        post :create, :equipment => { :name => 'Controller Creation' }
      end

      it { should redirect_to new_person_session_path }
    end

    describe 'An equipment exists. ' do
      before(:each) do
        @equipment = find_or_factory(:equipment)
      end

      describe 'GET :show the equipment' do
        before(:each) do
          get :show, :id => @equipment.id
        end

        it { should render_template 'show' }
        it { should assign_to(:equipment).with(@equipment) }
      end

      describe 'GET :edit the area' do
        before(:each) do
          get :edit, :id => @equipment.id
        end

        it { should redirect_to new_person_session_path }
      end

      describe 'PUT :update the equipment' do
        before(:each) do
          put :update, :id => @equipment.id, :area => { :name => 'new_equipment'}
        end

        it { should redirect_to new_person_session_path }
        it "should not change the equipment" do
          @equipment.reload
          @equipment.name.should_not be_eql('new_equipment')
        end
      end

      describe 'DELETE :destroy the equipment' do
        before(:each) do
          delete :destroy, :id => @equipment.id
        end

        it { should redirect_to new_person_session_path }
        it "should not destroy the equipment" do
          Equipment.exists?(@equipment.id).should be_true
        end
      end
    end
  end

  describe "Signed in as a normal user. " do
    before(:all) do
      company_2 = Factory.create(:company, :name => 'glbrc')

      @equipment_2 = Factory.create(:equipment, :name=>'glbrc_tractor', :company => company_2)
      @equipment_2.company = company_2
    end

    before(:each) do
      sign_in_as_normal_user

      @company_1 = @user.company
      @equipment_1 = find_or_factory(:equipment, :name =>'lter_tractor', :company_id => @company_1)
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

      it { should render_template 'authorized_index' }
      it { should assign_to(:equipment) }
    end

    describe 'GET :new' do
      before(:each) do
        get :new
      end

      it { should render_template 'new' }
      it { should assign_to(:equipment).with_kind_of(Equipment) }
    end

    describe "POST :create" do
      before(:each) do
        Equipment.exists?(:name => 'Controller Creation').should be_false
        post :create, :equipment => { :name => 'Controller Creation' }
      end

      it { should redirect_to equipment_path(assigns(:equipment)) }

      it 'should create an equipment' do
        Equipment.exists?(:name => 'Controller Creation').should be_true
      end

      it 'should assign the current company to the equipment' do
        assigns(:equipment).company.should == @company_1
      end

      it { should set_the_flash }
    end

    describe "POST :create with invalid attributes" do
      before(:each) do
        post :create, :equipment => { :name => "lter_tractor" } # Repeated name
      end

      it { should render_template 'new' }
      it { should_not set_the_flash }
    end

    describe "POST :create in xml format" do
      before(:each) do
        post :create,
          :format => 'xml',
          :equipment => { }
      end

      it { should respond_with_content_type(:xml) }
    end

    describe "An equipment exists. " do
      before(:each) do
        @equipment = find_or_factory(:equipment, :company_id => @user.company)
      end

      describe "GET :show the equipment" do
        before(:each) do
          get :show, :id => @equipment
        end

        it { should render_template 'show' }
        it { should assign_to(:equipment).with(@equipment) }
      end

      describe "GET :edit the equipment" do
        before(:each) do
          get :edit, :id => @equipment
        end

        it { should render_template 'edit' }
        it { should assign_to(:equipment).with(@equipment) }
      end

      describe "PUT :update the equipment with valid attributes" do
        before(:each) do
          put :update, :id => @equipment, :equipment => { :name => 'New Name' }
        end

        it { should redirect_to equipment_path(@equipment) }
        it 'should change the equipment' do
          @equipment.reload
          @equipment.name.should be_eql('New Name')
        end
      end

      #TODO is this just testing the validates helper again?
      describe "PUT :update the equipment with invalid attributes" do
        before(:each) do
          Factory.create(:equipment, :name => "Repeat_name", :company_id=>@user.company)
          put :update, :id => @equipment, :equipment => { :name => "Repeat_name"}
        end

        it { should render_template :edit }
        it { should assign_to(:equipment).with(@equipment) }
        it 'should not change the equipment' do
          @equipment.reload
          @equipment.name.should_not be_eql('Repeat Name')
        end
      end

      describe "DELETE :destroy the equipment" do
        before(:each) do
          delete :destroy, :id => @equipment
        end

        it { should redirect_to equipment_index_path }
        it "should destroy the equipment" do
          Equipment.exists?(@equipment.id).should be_false
        end
      end
    end
  end
end
