require 'spec_helper'

describe MaterialsController, type: :controller do
  render_views

  let(:material) { FactoryGirl.build_stubbed(:material, name: "custom material")}

  before :each do
    material.stub(:save).and_return(true)
    Material.stub(:persisted?).and_return(true)
    Material.stub(:find).with(material.id.to_s).and_return(material)
    Material.stub(:by_company).and_return(Material)
    # material.stub(:errors).and_return('')

    sign_in_as_normal_user
  end

  it "should get index" do
    get :index
    assert_response :success
    assert assigns(:materials)
  end

  describe 'GET new' do
    it "should render new" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST: create with valid attributes" do
    before(:each) do
      post :create, :material => { :name => 'NewName' }
    end

    it 'create the material' do
      expect(Material.exists?(assigns[:material])).to be_true
    end

    it 'redirects to new material' do
      expect(response).to redirect_to material_url(assigns(:material))
    end

  end

  describe "POST :create with invalid attributes" do
    before(:each) do
      post :create, :material => { :name => ''}
    end

    it { should render_template :new }
    it { should_not set_the_flash }
  end

  describe "POST :create with XML format" do
    before(:each) do
      post :create, :material => { :name => 'xml_name' }, :format => 'xml'
    end

    it { should respond_with(201) }
		it 'should respond with content type application/xml' do
			response.content_type.should == 'application/xml'
		end
  end

  describe 'GET show' do
    before(:each) do
      Material.should_receive(:find_with_children).with(material.id.to_s).and_return(material)
      get :show, :id => material
    end

    it 'renders the show template' do
      expect(response).to render_template :show
    end

    it "should assign the right material to @material" do
      expect(assigns(:material)).to eq material
    end
  end

  describe 'GET #edit' do
    it 'assigns the right material to @material' do
      get :edit, :id => material
      expect(assigns(:material)).to eq material
    end

    it 'renders template edit' do
      get :edit, :id => material
      expect(response).to render_template :edit
    end 
  end

  it "should update material" do
    put :update, :id => material, :material => { :name => 'updated_name' }
    assert_redirected_to material_path(assigns(:material))
  end


  describe "PUT :update with invalid attributes" do
    before(:each) do
      material.stub(:update_attributes).and_return(false)
      put :update, :id => material, :material => { :name => "repeat_name" }
    end

    it 'assigns to the right material' do
      expect(assigns(:material)).to eq material
    end

    it { should render_template :edit }
  end

  describe 'DESTROY' do
    before(:each) do
      material.stub(:destroy).and_return(true)
      delete :destroy, :id => material
    end

    it "should destroy material" do
      expect(Material.exists?(material)).to be_false
    end

    it 'redirects to index' do
      expect(response).to redirect_to materials_url
    end
  end
end
