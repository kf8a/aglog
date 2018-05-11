# frozen_string_literal: true

require 'spec_helper'

describe MaterialsController, type: :controller do
  render_views

  let(:material) { FactoryBot.create(:material, name: 'custom material') }

  before :each do
    allow(material).to receive(:save).and_return(true)
    allow(Material).to receive(:persisted?).and_return(true)
    allow(Material).to receive(:find).with(material.id.to_s).and_return(material)
    allow(Material).to receive(:by_company).and_return(Material)

    sign_in_as_normal_user
  end

  it 'should get index' do
    get :index
    assert_response :success
    assert assigns(:materials)
  end

  describe 'GET new' do
    it 'should render new' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST: create with valid attributes' do
    before(:each) do
      post :create, params: { material: { name: 'NewName' } }
    end

    it 'create the material' do
      expect(Material.exists?(assigns[:material].id)).to eq true
    end

    it 'redirects to new material' do
      expect(response).to redirect_to material_url(assigns(:material))
    end
  end

  describe 'POST :create with invalid attributes' do
    before(:each) do
      post :create, params: { material: { name: '' } }
    end

    it { should render_template :new }
    it { should_not set_flash }
  end

  describe 'POST :create with XML format' do
    before(:each) do
      post :create, params: { material: { name: 'xml_name' }, format: 'xml' }
    end

    it { should respond_with(201) }
    it 'should respond with content type application/xml' do
      expect(response.content_type).to eq 'application/xml'
    end
  end

  describe 'GET show' do
    before(:each) do
      expect(Material).to receive(:find_with_children).with(material.id.to_s).and_return(material)
      get :show, params: { id: material }
    end

    it 'renders the show template' do
      expect(response).to render_template :show
    end

    it 'should assign the right material to @material' do
      expect(assigns(:material)).to eq material
    end
  end

  describe 'GET #edit' do
    it 'assigns the right material to @material' do
      get :edit, params: { id: material }
      expect(assigns(:material)).to eq material
    end

    it 'renders template edit' do
      get :edit, params: { id: material }
      expect(response).to render_template :edit
    end
  end

  it 'should update material' do
    put :update, params: { id: material, material: { name: 'updated_name' } }
    assert_redirected_to material_path(assigns(:material))
  end

  describe 'PUT :update with invalid attributes' do
    before(:each) do
      allow(material).to receive(:update_attributes).and_return(false)
      put :update, params: { id: material, material: { name: 'repeat_name' } }
    end

    it 'assigns to the right material' do
      expect(assigns(:material)).to eq material
    end

    it { should render_template :edit }
  end

  describe 'DESTROY' do
    before(:each) do
      # allow(material).to receive(:destroy).and_return(true)
      delete :destroy, params: { id: material }
    end

    it 'should destroy material' do
      expect(Material.exists?(material.id)).to eq false
    end

    it 'redirects to index' do
      expect(response).to redirect_to materials_url
    end
  end
end
