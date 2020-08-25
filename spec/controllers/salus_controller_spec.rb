# frozen_string_literal: true

RSpec.describe SalusController, type: :controller do
  describe 'GET #show' do
    it 'returns http success' do
      @area = find_or_factory :area
      get :show, params: { id: @area.id, format: :xml }
      expect(response).to have_http_status(:success)
    end
  end
end
