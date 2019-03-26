# frozen_string_literal: true

RSpec.describe SalusController, type: :controller do
  describe 'GET #show' do
    it 'returns http success' do
      @area = FactoryBot.create :area
      get :show, params: { id: @area.id, format: :xml }
      expect(response).to have_http_status(:success)
    end
  end
end
