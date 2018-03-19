require 'spec_helper'

describe PeopleController, type: :controller  do
  render_views

  let(:person) { FactoryBot.build_stubbed(:person, sur_name: 'hastings', given_name: 'bill')}

  before :each do
    allow(Person).to receive(:persisted?).and_return(true)
    allow(Person).to receive(:find).with(person.id.to_s).and_return(person)
    allow(person).to receive(:save).and_return(true)
  end

  describe 'as a guest user' do
    describe 'GET :index' do
      before(:each) do
        expect(Person).to receive(:ordered).and_return([person])
        get :index
      end
      it 'renders the index template' do
        expect(response).to render_template 'index'
      end
      it 'assigns people to @people' do
        expect(assigns(:people)).to match_array [person]
      end
    end

    it 'does not allow GET :new' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow GET :edit' do
      get :edit, :id => person
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow POST :create' do
      post :create, :person => {:sur_name => 'Smith', :given_name => 'Barb'}
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow PUT :update' do
      put :update, :id => person, :person => {:sur_name => 'Brown'}
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not allow DELETE :destroy' do
      delete :destroy, :id => person
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'as an authenticated user' do
    before(:each) do 
      sign_in_as_normal_user
    end

    describe 'GET :index' do
      before(:each) do
        expect(Person).to receive(:ordered_in_company).with(controller.current_user.company).and_return([person])
        get :index
      end

      it 'shows the current companies users' do
        expect(assigns(:people)).to match_array [person]
      end

      # it 'does not show other companies users' do
      #   expect(assigns(:people)).to_not include [other_person]
      # end

      it 'renders the index template' do
        expect(response).to render_template 'index'
      end
    end

    describe 'GET :show' do
      before(:each) do
        get :show, :id => person
      end

      it 'renders the show template' do
        expect(response).to render_template 'show'
      end
      it 'assigns the right person to @person' do
        expect(assigns(:person)).to eq person
      end
    end

    describe 'GET :new' do
      before(:each) do
        get :new
      end
      it 'renders template new' do
        expect(response).to render_template 'new'
      end
      it 'assigns new Person to @person' do
        expect(assigns(:person)).to be_a_new(Person)
      end
    end

    describe 'POST :create' do
      context 'with valid parameters' do
        before(:each) do
          post :create, :person => {:sur_name => 'Brown', :given_name => 'Bill' }
        end

        it 'creates a new person' do
          expect(Person.exists?(assigns(:person).id)).to eq true 
        end
        it 'redirects to the new person' do
          expect(response).to redirect_to Person.last
        end
      end

    end

    describe 'GET :edit' do
      before(:each) do
        expect(Person).to receive(:find_in_company).with(controller.current_user.company, person.id.to_s).and_return(person)
        get :edit, :id => person
      end

      it 'finds the right person' do
        expect(assigns(:person)).to eq person
      end

      it 'renders the edit template' do
        expect(response).to render_template 'edit'
      end
    end

    describe 'PUT :update' do
      context 'with valid parameters' do
        before(:each) do
          expect(Person).to receive(:find_in_company).with(controller.current_user.company, person.id.to_s).and_return(person)
          expect(person).to receive(:update_attributes).with({'given_name' => 'Bob'}).and_return(true)
          put :update, :id => person, :person => {:given_name => 'Bob'}
        end

        it 'redirects to the person' do
          expect(response).to redirect_to person
        end
        # it {should set_the_flash}
      end

      context 'with invalid parametes' do
      end
    end

    describe 'DELETE :destroy' do
      before(:each) do
        allow(person).to receive(:destroy).and_return(true)
        delete :destroy, :id => person
      end

      it 'deletes the person' do
        expect(Person.exists?(person.id)).to eq false 
      end

      it 'redirects to index' do
        expect(response).to redirect_to people_url
      end
    end
  end
end
