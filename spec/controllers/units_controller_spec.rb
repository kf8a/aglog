require 'spec_helper'

describe UnitsController, type: :controller  do
  render_views

  let(:unit) { FactoryGirl.build_stubbed(:unit, name: 'custom unit')}

  before :each do
    Unit.stub(:persisted?).and_return(true)
    Unit.stub(:find).and_return(unit)
    unit.stub(:save).and_return(true)
  end

  describe "Signed in as a normal user. " do
    before(:each) do
      sign_in_as_normal_user
    end

    describe "GET :new" do
      before(:each) do
        get :new
      end

      it { should respond_with :success }
      it { should render_template :new }
    end

    describe "GET :index" do
      before(:each) do
        get :index
      end

      it { should respond_with :success }
      it { should render_template :index }
    end

    describe "POST :create with valid parameters" do
      before(:each) do
        post :create, :unit => {:name => "test_name"}
      end

      it { should redirect_to unit_path(assigns(:unit)) }
      it { should set_the_flash.to("Unit was successfully created.")}
    end

    describe "POST :create in XML format" do
      before(:each) do
        post :create, :unit => { :name => 'xml_name' }, :format => 'xml'
      end

      it { should respond_with(201) }
			it 'should respond with content type application/xml' do
				response.content_type.should == 'application/xml'
			end
    end

    describe "A unit exists. " do

      describe "GET :edit the unit" do
        before(:each) do
          get :edit, :id => unit
        end

        it  'should assign the requested unit to @unit' do
          expect(assigns(:unit)).to eq unit 
        end

        it { should respond_with :success }
        it { should render_template :edit }
      end

      describe "GET :show the unit" do
        before(:each) do
          get :show, :id => unit
        end

        it 'should assign the requested unit to @unit' do
          expect(assigns(:unit)).to eq unit
        end

        it { should respond_with :success }
        it { should render_template :show }
      end

      describe "PUT :update the unit with valid attributes" do
        before(:each) do
          unit.stub(:update_attributes).and_return(true)
          put :update, :id => unit, :unit => {:name => "different_name"}
        end

        it 'assings the unit to @unit' do
          expect(assigns(:unit)).to eq(unit)
        end

        it 'redirects to the show page' do
          expect(response).to redirect_to unit_path(assigns(:unit))
        end
      end

      describe "PUT :update the unit with invalid attributes" do
        before(:each) do
          unit.stub(:update_attributes).and_return(false)
          put :update, :id => unit, :unit => {:name => "repeat_name"}
        end

        it 'locates the requested @unit' do
          expect(assigns(:unit)).to eq(unit)
        end

        it 'should render the edit template' do
          expect(response).to render_template :edit
        end
      end

      describe "DELETE :destroy the unit" do
        before(:each) do
          unit.stub(:destroy).and_return(true)
          delete :destroy, :id => unit
        end

        it 'deletes the unit' do
          expect(Unit.exists?(unit)).to eq false
        end

        it 'redirects to index' do
          expect(response).to redirect_to units_url
        end
      end

    end
  end
end
