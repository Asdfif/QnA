require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #rewards' do
    context 'Authenticated user' do
      before do
        login(user)
        get :rewards, params: { id: user }
      end
    
      it 'renders rewards view' do
        expect(response).to render_template :rewards
      end
    end

    context 'Authenticated user' do
      before do
        get :rewards, params: { id: user }
      end

      it 'does not renders rewards view' do
        expect(response).to_not render_template :rewards
      end
    end
  end
end
