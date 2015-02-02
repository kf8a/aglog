require 'spec_helper'

describe ObservationsController, type: :controller  do
  render_views

  let(:observation) { FactoryGirl.build_stubbed(:observation)}

  before :each do
    observation.stub(:save).and_return(true)
    Observation.stub(:persisted?).and_return(true)
    Observation.stub(:find).and_return([observation])
    Observation.stub(:find).with(observation.id.to_s).and_return(observation)
    Observation.stub(:by_company).and_return(Observation)
  end

  describe 'an unauthenticated user' do
    describe 'GET :index' do
      it 'should be successful' do
        get :index
        expect(response).to render_template 'index'
      end
    end

    it 'does not allow GET :new' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow GET :edit' do
      get :edit, :id => observation
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow PUT :update' do
      put :update, :id => observation, :observation => {}
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow POST :create' do
      post :create, :observation => {:observation_date => Date.today}
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow DELETE :destroy' do
      delete :destroy, :id => observation
      expect(response).to redirect_to new_user_session_path
    end

   end

  describe 'as an an authenticated user' do
    before(:each) do
      sign_in_as_normal_user
    end

    describe 'GET :index' do
      before(:each) do
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template 'index'
      end

      # TODO figure out how test that is assings the right array
      # it 'assigns the observations to @observation' do
      #   expect(assigns(:observations)).to match_array [observation]
      # end
    end

  #   before(:each) do
  #     sign_in_as_normal_user
  #     Equipment.find_by_id(2) or 2.times do |num|
  #       FactoryGirl.create(:equipment, :name => "Equipment#{num}")
  #     end
  #     Material.find_by_id(3) or 3.times do |num|
  #       FactoryGirl.create(:material, :name => "Material#{num}")
  #     end
  #     Unit.find_by_id(3) or 3.times do |num|
  #       FactoryGirl.create(:unit, :name => "Unit#{num}")
  #     end
  #     Person.find_by_id(2) or 2.times do |num|
  #       FactoryGirl.create(:person, :sur_name => "Sur#{num}")
  #     end
  #   end

    describe "GET :index, with observation type selected" do
      before(:each) do
        observation_type = FactoryGirl.build_stubbed(:observation_type)
        ObservationType.stub(:find).with(observation_type.id).and_return(observation_type)
        observation.observation_types << observation_type
        get :index, :obstype => observation_type

        # right_type = find_or_factory(:observation_type)
        # @correct_type_observation = FactoryGirl.create(:observation,
        #                                            :company_id => @user.company.id)
        # @correct_type_observation.observation_types << right_type
        # @correct_type_observation.save
        # wrong_type = find_or_factory(:observation_type,
        #                              :name => 'wrong_type')
        # @wrong_type_observation = FactoryGirl.create(:observation,
        #                                          :company_id => @user.company.id)
        # @wrong_type_observation.observation_types = [wrong_type]
        # @wrong_type_observation.save

        # assert @correct_type_observation.observation_types.include?(right_type)
        # assert !@wrong_type_observation.observation_types.include?(right_type)
        # get :index, :obstype => right_type.id
      end

      # it 'should include observations of the correct type' do
      #   expect(assigns(:observation)).to match_array [observation]
      # end

      # it "should only include observation of correct type" do
      #   assert  assigns(:observations).include?(@correct_type_observation)
      #   assert !assigns(:observations).include?(@wrong_type_observation)
      # end
    end

    describe "GET :index in salus_xml format" do
      before(:each) do
        get :index, :format => 'salus_xml'
      end

			it 'should respond with content type text/xml' do
        expect(response.content_type).to eq 'text/xml'
			end
    end

    describe "GET :index in salus_csv format" do
      before(:each) do
        get :index, :format => 'salus_csv'
      end

			it 'should respond with content type test/text' do
        expect(response.content_type). to eq 'text/text'
			end
    end

    describe "GET :new" do
      before(:each) do
        get :new
      end

      it 'should assign a new observation to @observation' do
        expect(assigns(:observation)).to be_a_new(Observation)
      end
      it { should render_template 'new' }
    end

  #   describe "POST :create" do
  #     before(:each) do
  #       @observation_count = Observation.count
  #       observation_type_id = ObservationType.first.id
  #       post :create, :observation => { :observation_date => Date.today,
  #         :observation_type_ids => [observation_type_id] }
  #     end

  #     it "should create an observation" do
  #       assert_equal @observation_count + 1, Observation.count
  #     end

  #     it "should assign the current user as the observation's person" do
  #       assert_equal @user.person.id, assigns(:observation).person_id
  #     end
  #   end

  #   it "should not create observation or activity" do
  #     old_count = Observation.count
  #     num_activities =  Activity.count

  #     xhr(:post, :create, :commit => "Create Observation", :observation => {})
  #     assert_equal old_count, Observation.count
  #     assert_equal num_activities, Activity.count
  #     assert_response :success

  #     xhr(:post, :create, :commit => "Create Observation", :observation => {:observation_date => 'nodate'})
  #     assert_equal old_count, Observation.count

  #     xhr(:post, :create, :commit => "Create Observation", :observation => {:observation_date => Date.today},
  #         :activity => {0 => {:user_id => 50}})
  #     assert_equal old_count, Observation.count
  #     assert_equal num_activities, Activity.count
  #     assert_response :success
  #   end

  #   describe "An observation exists. " do
  #     before(:each) do
  #       @observation = FactoryGirl.create(:observation)
  #       @observation.company = @user.company
  #       @observation.save
  #     end

  #     describe "GET :show the observation" do
  #       before(:each) do
  #         get :show, :id => @observation.id
  #       end

  #       it { should render_template 'show' }
  #     end

  #     describe "GET :edit the observation" do
  #       before(:each) do
  #         get :edit, :id => @observation.id
  #       end

  #       it { should render_template 'edit' }
  #     end

  #     describe "PUT :update the observation" do
  #       before(:each) do
  #         @current_obs_date = @observation.obs_date
  #         xhr(:put, :update, :id => @observation.id, :commit => "Update Observation", :observation => { :observation_date => @current_obs_date - 1 })
  #       end

  #       it "should update the observation" do
  #         @observation.reload
  #         assert_equal @current_obs_date - 1, @observation.obs_date
  #       end
  #     end

      describe "DELETE :destroy the observation" do
        before(:each) do
          observation.stub(:destroy).and_return(true)
          delete :destroy, :id => observation
        end

        it 'should remove the observation' do
          expect(Observation.exists?(observation)).to be_false
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
  # private###########

  # def default_params(commit_text)

  #       {"observation"=>{"obs_date(1i)"=>"2007", "obs_date(2i)"=>"6", "obs_date(3i)"=>"27",
  # 		  "areas_as_text"=>"", "comment"=>""},
  # 		  "commit"=>commit_text, "activity_index"=>"0",
  # 		  "setup_index"=>"0", :id => '',
  # 		  "activities"=>{
  # 		    "0"=>{"setups"=>{
  # 		      "0"=>{"equipment_id"=>"2", "material_transactions"=>{
  # 		        "0"=>{"material_id"=>"3", "rate"=>"5", "unit_id"=>"3"}}}},
  # 		        "hours"=>"1", "person_id"=>"2"}},
  # 		        "controller"=>"observations", "material_index"=>"0"}
  # end
end
