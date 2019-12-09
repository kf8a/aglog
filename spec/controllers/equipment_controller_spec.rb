# frozen_string_literal: true

describe EquipmentController, type: :controller  do
  render_views

  let(:company) { find_or_factory(:company, name: 'lter') }
  let(:equipment) { find_or_factory(:equipment, company: company) }

  describe 'Not signed in. ' do
    before do
      @equipment = FactoryBot.create(:equipment, company: company)
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
      post :create, params: { equipment: { name: 'Controller Creation',
                                           equipment_pictures: [] } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'shows equipment' do
      get :show, params: { id: @equipment.id }
      expect(response).to render_template 'show'
    end

    it 'does now allow edit' do
      get :edit, params: { id: @equipment.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow updates' do
      put :update, params: { id: @equipment.id, area: { name: 'new_equipment' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow deletes' do
      delete :destroy, params: { id: @equipment.id }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'Signed in as a normal user. ' do
    before(:each) do
      company2 = find_or_factory(:company, name: 'glbrc')

      @equipment2 = find_or_factory(:equipment, name: 'glbrc_tractor',
                                                company: company2)
    end

    before(:each) do
      sign_in_as_normal_user

      @equipment1 = find_or_factory(:equipment, name: 'lter_tractor')
    end

    after(:all) do
      @equipment1 = nil
      @equipment2 = nil
    end

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it { should render_template 'index' }

    end

    it 'allows new' do
      get :new
      expect(response).to render_template 'new'
    end

    describe 'POST :create' do
      it 'should create an equipment' do
        expect(Equipment).to receive(:new).with(any_args).and_call_original
        post :create, params: { equipment: { name: 'Controller Creation' } }
      end

      it 'redirects to the new equipment' do
        post :create, params: { equipment: { name: 'Controller Creation',
                                             company_id: @user.companies.first } }
        expect(response).to redirect_to equipment_path(assigns(:equipment))
      end
    end

    describe 'POST :create with invalid attributes' do
      before(:each) do
        post :create, params: { equipment: { name: 'lter_tractor' } } # Repeated name
      end

      it { is_expected.to render_template 'new' }
      it { is_expected.to_not set_flash }
    end

    describe 'An equipment exists. ' do
      before(:each) do
        @equipment = find_or_factory(:equipment,
                                     company_id: @user.companies.first)
      end

      describe 'GET :show the equipment' do
        before(:each) do
          get :show, params: { id: @equipment }
        end

        it { is_expected.to render_template 'show' }
      end

      describe 'GET :edit the equipment' do
        before(:each) do
          get :edit, params: { id: @equipment }
        end

        it { is_expected.to render_template 'edit' }
      end

      describe 'PUT :update the equipment with valid attributes' do
        before(:each) do
          put :update, params: { id: @equipment, equipment: { name: 'New Name' } }
        end

        it { is_expected.to redirect_to equipment_path(@equipment) }
        it 'should change the equipment' do
          @equipment.reload
          expect(@equipment.name).to eql('New Name')
        end
      end

      describe 'PUT :update the equipment with invalid attributes' do
        before(:each) do
          @equipment =
            find_or_factory(:equipment, name: 'Repeat_name',
                                        company: @user.companies.first)
          put :update, params: { id: @equipment,
                                 equipment: { name: 'new name', company_id: nil } }
        end

        it { is_expected.to render_template :edit }
      end

      describe 'DELETE :destroy the equipment' do
        before(:each) do
          delete :destroy, params: { id: @equipment }
        end

        it { is_expected.to redirect_to equipment_index_path }

        it 'should destroy the equipment' do
          expect(Equipment.exists?(@equipment.id)).to eq false
        end
      end
    end
  end
end
