# frozen_string_literal: true

describe AreasController, type: :controller do
  render_views

  let(:company) { find_or_factory(:company, name: 'lter') }
  let(:area) { find_or_factory(:area, name: 'custom_area', company: company) }

  before :each do
    allow(area).to receive(:save).and_return(true)
    allow(Area).to receive(:persisted?).and_return(true)
    allow(Area).to receive(:find).with(area.id.to_s).and_return(area)
    allow(Area).to receive(:by_company).and_return(Area)
  end

  describe 'Not signed in. ' do
    describe 'GET :index' do
      before(:each) { get :index }

      it { should render_template 'index' }
    end

    it 'does not allow GET :new' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    describe 'POST :create' do
      before(:each) { post :create, params: { area: { name: 'T2R22' } } }

      it 'redirects to the login page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not create the area' do
        expect(Area.exists?(name: 'T2R22')).to eq false
      end
    end

    describe 'GET :show the area' do
      before(:each) { get :show, params: { id: area } }

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it { should render_template 'show' }
    end

    it 'does not allow GET :edit' do
      get :edit, params: { id: area }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow PUT :update' do
      put :update, params: { id: area, area: { name: 'new_area' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow destroy' do
      delete :destroy, params: { id: area }
      expect(response).to redirect_to new_user_session_path
    end

    # describe 'The area is a branch with leaves that have observations. ' do
    #   before(:each) do
    #     @area1 = FactoryBot.create(:area, company_id: 1)
    #     @area1.observations << FactoryBot.create(:observation)
    #     @area1.move_to_child_of(@area)
    #     assert @area.leaves.include?(@area1)
    #   end

    #   describe 'GET :show the area' do
    #     before(:each) do
    #       get :show, :id => @area.id
    #     end

    #   end
    # end
  end

  describe 'Signed in as normal user. ' do
    before(:each) { sign_in_as_normal_user }

    describe 'GET :index' do
      before(:each) { get :index }

      it { should render_template 'index' }
    end

    describe 'GET :new' do
      before(:each) { get :new }

      it 'renders the template new' do
        expect(response).to render_template 'new'
      end

      it 'assigns a new area to @area' do
        expect(assigns(:area)).to be_a_new(Area)
      end
    end

    describe 'POST :create' do
      before(:each) { post :create, params: { area: { name: 'T2R22' } } }

      it { should redirect_to area_path(assigns(:area)) }
      it 'should create an area' do
        expect(Area.exists?(name: 'T2R22')).to eq true
      end
      it { should set_flash }
    end

    describe 'POST :create with invalid attributes' do
      before(:each) do
        allow_any_instance_of(Area).to receive(:valid?).and_return(false)
        post :create, params: { area: { name: 'repeat_name' } }
      end

      it { should render_template 'new' }
      it { should_not set_flash }
    end

    describe 'GET :show the area' do
      before(:each) { get :show, params: { id: area } }

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it { should render_template 'show' }
    end

    describe 'GET :edit the area' do
      before(:each) { get :edit, params: { id: area } }

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it { should render_template 'edit' }
    end

    describe 'PUT :update the area with valid attributes' do
      before(:each) { put :update, params: { id: area, area: { name: 'new_area' } } }

      it { should redirect_to area_url(assigns(:area)) }

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it 'should change the area' do
        expect(area.name).to eq 'new_area'
      end
    end

    describe 'PUT :update with invalid attributes' do
      before(:each) do
        allow(area).to receive(:update).and_return(false)
        subject { put :update, params: { id: area, area: { name: 'repeat_name' } } }
      end

      it 'assigns the right area to @area' do
        expect(assigns(:area)).to eq area
      end

      it 'should not change the area' do
        expect(area.name).to_not eq 'repeat_name'
      end

      it 'should render_template :edit' do
        expect(subject).to render_template 'edit'
      end
    end

    describe 'DELETE :destroy the area' do
      before(:each) do
        allow(area).to receive(:destroy).and_return(true)
        delete :destroy, params: { id: area }
      end

      it { should redirect_to areas_path }
    end
  end
end
