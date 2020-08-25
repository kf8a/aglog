describe UnitsController, type: :controller do
  render_views

  let(:unit) { FactoryBot.build_stubbed(:unit, name: 'custom unit') }

  before :each do
    allow(Unit).to receive(:persisted?).and_return(true)
    allow(Unit).to receive(:find).and_return(unit)
    allow(unit).to receive(:save).and_return(true)
  end

  describe 'Signed in as a normal user. ' do
    before(:each) { sign_in_as_normal_user }

    describe 'GET :new' do
      before(:each) { get :new }

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :new }
    end

    describe 'GET :index' do
      before(:each) { get :index }

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :index }
    end

    describe 'POST :create with valid parameters' do
      before(:each) { post :create, params: { unit: { name: 'test_name' } } }

      it { is_expected.to redirect_to unit_path(assigns(:unit)) }
      it { is_expected.to set_flash.to('Unit was successfully created.') }
    end

    describe 'POST :create in XML format' do
      before(:each) { post :create, params: { unit: { name: 'xml_name' }, format: 'xml' } }

      it { is_expected.to respond_with(201) }
      it 'should respond with content type application/xml' do
        expect(response.content_type).to eq 'application/xml'
      end
    end

    describe 'A unit exists. ' do
      describe 'GET :edit the unit' do
        before(:each) { get :edit, params: { id: unit } }

        it 'should assign the requested unit to @unit' do
          expect(assigns(:unit)).to eq unit
        end

        it { is_expected.to respond_with :success }
        it { is_expected.to render_template :edit }
      end

      describe 'GET :show the unit' do
        before(:each) { get :show, params: { id: unit } }

        it 'should assign the requested unit to @unit' do
          expect(assigns(:unit)).to eq unit
        end

        it { is_expected.to respond_with :success }
        it { is_expected.to render_template :show }
      end

      describe 'PUT :update the unit with valid attributes' do
        before(:each) do
          allow(unit).to receive(:update_attributes).and_return(true)
          put :update, params: { id: unit, unit: { name: 'different_name' } }
        end

        it 'assings the unit to @unit' do
          expect(assigns(:unit)).to eq(unit)
        end

        it 'redirects to the show page' do
          expect(response).to redirect_to unit_path(assigns(:unit))
        end
      end

      describe 'PUT :update the unit with invalid attributes' do
        before(:each) do
          allow(unit).to receive(:update_attributes).and_return(false)
          put :update, params: { id: unit, unit: { name: 'repeat_name' } }
        end

        it 'locates the requested @unit' do
          expect(assigns(:unit)).to eq(unit)
        end

        it 'should render the edit template' do
          expect(response).to render_template :edit
        end
      end

      describe 'DELETE :destroy the unit' do
        before(:each) do
          allow(unit).to receive(:destroy).and_return(true)
          delete :destroy, params: { id: unit }
        end

        it 'deletes the unit' do
          expect(Unit.exists?(unit.id)).to eq false
        end

        it 'redirects to index' do
          expect(response).to redirect_to units_url
        end
      end
    end
  end
end
