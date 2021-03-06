# frozen_string_literal: true

describe ObservationsController, type: :controller do
  render_views

  let(:observation) { FactoryBot.build_stubbed(:observation) }

  before :each do
    allow(observation).to receive(:save).and_return(true)
    allow(Observation).to receive(:persisted?).and_return(true)
    allow(Observation).to receive(:find).and_return([observation])
    allow(Observation).to receive(:find).with(observation.id.to_s).and_return(observation)
  end

  describe 'an unauthenticated user' do
    describe 'GET :index' do
      it 'should be successful' do
        get :index
        expect(response).to render_template 'index'
      end
    end

    it 'retrieves by year' do
      get :index, params: { year: 2015 }
      expect(response).to render_template 'index'
    end

    it 'does not allow GET :new' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow GET :edit' do
      get :edit, params: { id: observation }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow PUT :update' do
      put :update, params: { id: observation, observation: {} }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow POST :create' do
      post :create, params: { observation: { observation_date: Date.today } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow DELETE :destroy' do
      delete :destroy, params: { id: observation }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'as an an authenticated user' do
    before(:each) { sign_in_as_normal_user }

    describe 'GET :index' do
      before(:each) { get :index }

      it 'renders the index template' do
        expect(response).to render_template 'index'
      end

      # TODO: figure out how test that is assings the right array
      # it 'assigns the observations to @observation' do
      #   expect(assigns(:observations)).to match_array [observation]
      # end
    end

    describe 'GET :index, with observation type selected' do
      before(:each) do
        observation_type = FactoryBot.build_stubbed(:observation_type)
        allow(ObservationType).to receive(:find).with(observation_type.id).and_return(observation_type)
        observation.observation_types << observation_type
        get :index, params: { obstype: observation_type }

        right_type = find_or_factory(:observation_type)
        @correct_type_observation =
          FactoryBot.create(:observation), @correct_type_observation.observation_types << right_type
        @correct_type_observation.save
        wrong_type = find_or_factory(:observation_type, name: 'wrong_type')
        @wrong_type_observation = FactoryBot.create(:observation)
        @wrong_type_observation.observation_types = [wrong_type]
        @wrong_type_observation.save

        assert @correct_type_observation.observation_types.include?(right_type)
        assert !@wrong_type_observation.observation_types.include?(right_type)
        get :index, params: { obstype: right_type.id }
      end

      # it 'should include observations of the correct type' do
      #   expect(assigns(:observation)).to match_array [observation]
      # end

      # it "should only include observation of correct type" do
      #   assert  assigns(:observations).include?(@correct_type_observation)
      #   assert !assigns(:observations).include?(@wrong_type_observation)
      # end
    end

    describe 'GET :index in salus_xml format' do
      before(:each) { get :index, params: { format: 'salus_xml' } }

      it 'should respond with content type text/xml' do
        expect(response.content_type).to eq 'text/xml'
      end
    end

    describe 'GET :index in salus_csv format' do
      before(:each) { get :index, params: { format: 'salus_csv' } }

      it 'should respond with content type test/text' do
        expect(response.content_type).to eq 'text/text'
      end
    end

    describe 'GET :new' do
      before(:each) { get :new }

      it 'should assign a new observation to @observation' do
        expect(assigns(:observation)).to be_a_new(Observation)
      end
      it { should render_template 'new' }
    end

    describe 'POST :create' do
      before(:each) do
        @observation_count = Observation.count
        observation_type = FactoryBot.create :observation_type
        post :create,
             params: { observation: { observation_date: Date.today, observation_type_ids: [observation_type.id] } }
      end

      it 'should create an observation' do
        assert_equal @observation_count + 1, Observation.count
      end

      it "should assign the current user as the observation's person" do
        assert_equal @user.person.id, assigns(:observation).person_id
      end
    end

    describe 'An observation exists. ' do
      before(:each) do
        observation_type = FactoryBot.create :observation_type
        person = Person.first_or_create
        @observation = FactoryBot.create(:observation, person: person, observation_types: [observation_type])
        expect(@observation.save)
      end

      describe 'GET :show the observation' do
        before(:each) { get :show, params: { id: @observation.id } }

        it { should render_template 'show' }
      end

      describe 'GET :edit the observation' do
        before(:each) { get :edit, params: { id: @observation.id } }

        it { should render_template 'edit' }
      end

      describe 'PUT :update the observation' do
        before(:each) do
          @current_obs_date = @observation.obs_date
          xhr(
            :put,
            :update,
            params: {
              id: @observation.id,
              commit: 'Update Observation',
              observation: { observation_date: @current_obs_date - 1 }
            }
          )
        end

        # it 'should update the observation' do
        #   @observation.reload
        #   assert_equal @current_obs_date - 1, @observation.obs_date
        # end
      end

      describe 'PUT :update the observation with new files' do
        pending 'figure how to test addition of files'
      end

      describe 'DELETE :destroy the observation' do
        before(:each) do
          allow(observation).to receive(:destroy).and_return(true)
          delete :destroy, params: { id: observation }
        end

        it 'should remove the observation' do
          expect(Observation.exists?(observation.id)).to eq false
        end

        it { should redirect_to observations_path }
      end

      # describe "GET :related" do
      #   it 'should render related template' do
      #     get :related, :id => observation
      #     expect(response).to render_template 'related'
      #   end
      # end
    end
  end

  private

  def default_params(commit_text)
    {
      'observation': {
        'obs_date(1i)': '2007', 'obs_date(2i)': '6', 'obs_date(3i)': '27', 'areas_as_text': '', 'comment': ''
      },
      'commit': commit_text,
      'activity_index': '0',
      'setup_index': '0',
      id: '',
      'activities' => {
        '0': {
          'setups': {
            '0': {
              'equipment_id': '2', 'material_transactions': { '0': { 'material_id': '3', 'rate': '5', 'unit_id': '3' } }
            }
          },
          'hours': '1',
          'person_id': '2'
        }
      },
      'controller': 'observations',
      'material_index': '0'
    }
  end
end
