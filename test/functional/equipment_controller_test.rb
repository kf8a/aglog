require 'test_helper'

class EquipmentControllerTest < ActionController::TestCase

  context 'Not signed in. ' do
    setup do
      sign_out
    end

    context 'GET :index' do
      setup do
        get :index
      end

      should render_template 'unauthorized_index'
      should assign_to :equipment
    end

    context 'GET :new' do
      setup do
        get :new
      end

      should ("redirect to the sign in page"){ redirect_to new_person_session_url }
    end

    context 'POST :create' do
      setup do
        assert_nil Equipment.find_by_name('Controller Creation')
        post :create, :equipment => { :name => 'Controller Creation' }
      end

      should ("redirect to the sign in page"){ redirect_to new_person_session_url }
      should 'not create an equipment' do
        assert_nil Equipment.find_by_name('Controller Creation')
      end
    end

    context 'An equipment exists. ' do
      setup do
        @equipment = Factory.create(:equipment)
      end

      context 'GET :show the equipment' do
        setup do
          get :show, :id => @equipment.id
        end

        should render_template 'show'
        should assign_to(:equipment).with(@equipment)
      end

      context 'GET :edit the area' do
        setup do
          get :edit, :id => @equipment.id
        end

        should ("redirect to the sign in page"){ redirect_to new_person_session_url }
      end

      context 'PUT :update the equipment' do
        setup do
          put :update, :id => @equipment.id, :area => { :name => 'new_equipment'}
        end

        should ("redirect to the sign in page"){ redirect_to new_person_session_url }
        should "not change the equipment" do
          @equipment.reload
          refute_equal 'new_equipment', @equipment.name
        end
      end

      context 'DELETE :destroy the equipment' do
        setup do
          delete :destroy, :id => @equipment.id
        end

        should ("redirect to the sign in page"){ redirect_to new_person_session_url }
        should "not destroy the equipment" do
          assert Equipment.find_by_id(@equipment.id)
        end
      end
    end
  end

  context "Signed in as a normal user. " do
    setup do
      sign_in_as_normal_user
    end

    context 'GET :index' do
      setup do
        get :index
      end

      should render_template 'authorized_index'
      should assign_to(:equipment)
    end

    context 'GET :new' do
      setup do
        get :new
      end

      should render_template 'new'
      should assign_to(:equipment).with_kind_of(Equipment)
    end

    context "POST :create" do
      setup do
        assert_nil Equipment.find_by_name('Controller Creation')
        post :create, :equipment => { :name => 'Controller Creation' }
      end

      should ("redirect to the show page"){ redirect_to equipment_path(assigns(:equipment)) }
      should 'create an equipment' do
        assert Equipment.find_by_name('Controller Creation')
      end
      should set_the_flash
    end
    
    context "POST :create with invalid attributes" do
      setup do
        Factory.create(:equipment, :name => "Repeat_name")
        post :create, :equipment => { :name => "Repeat_name" }
      end

      should render_template 'new'
      should_not set_the_flash
    end

    context "POST :create in xml format" do
      setup do
        post :create,
             :format => 'xml',
             :equipment => { }
      end

      should respond_with(201)
      should respond_with_content_type(:xml)
    end

    context "An equipment exists. " do
      setup do
        @equipment = Factory.create(:equipment)
      end

      context "GET :show the equipment" do
        setup do
          get :show, :id => @equipment
        end

        should render_template 'show'
        should assign_to(:equipment).with(@equipment)
      end

      context "GET :edit the equipment" do
        setup do
          get :edit, :id => @equipment
        end

        should render_template 'edit'
        should assign_to(:equipment).with(@equipment)
      end

      context "PUT :update the equipment with valid attributes" do
        setup do
          put :update, :id => @equipment, :equipment => { :name => 'New Name' }
        end

        should redirect_to("the show page for the equipment") {equipment_path(@equipment)}
        should 'change the equipment' do
          @equipment.reload
          assert_equal 'New Name', @equipment.name
        end
      end

      context "PUT :update the equipment with invalid attributes" do
        setup do
          Factory.create(:equipment, :name => "Repeat_name")
          put :update, :id => @equipment, :equipment => { :name => "Repeat_name"}
        end

        should render_template :edit
        should assign_to(:equipment).with(@equipment)
        should 'not change the equipment' do
          @equipment.reload
          refute_equal 'Repeat Name', @equipment.name
        end
      end

      context "DELETE :destroy the equipment" do
        setup do
          delete :destroy, :id => @equipment
        end

        should redirect_to("the equipment index page") {equipment_index_path}
        should "destroy the equipment" do
          assert_nil Equipment.find_by_id(@equipment)
        end
      end
    end
  end
  

  
end
