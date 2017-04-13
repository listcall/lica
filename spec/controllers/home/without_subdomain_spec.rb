require 'rails_helper'

# noinspection RubyArgCount
describe HomeController, 'without subdomain' do

  context 'as a public user' do

    describe 'GET index' do

      it 'has appropriate current-object values' do
        get :index
        expect(controller.current_user).to       be_nil
        expect(controller.current_team).to       be_nil
        expect(controller.current_membership).to be_nil
      end

      it 'redirects to http:///info/domain_not_found' do
        expect(request.subdomain).to eq('')
        get :index
        expect(response.status).to eq(302)
        expect(response).to redirect_to 'http:///info/domain_not_found'
      end

    end

  end

  context 'as a logged-in active member'

  context 'as a logged-in inactive member'

  context 'as a logged-in non-member' do

    before(:each) do
      @user = FG.create :user
      session[:user_id] = @user.id
    end

    describe 'Get index' do

      it 'has appropriate current-object values' do
        get :index
        expect(controller.current_user).to       eq(@user)
        expect(controller.current_team).to       be_nil
        expect(controller.current_membership).to be_nil
      end

      it 'redirects to http:///info/domain_not_found' do
        get :index
        expect(response).to redirect_to 'http:///info/domain_not_found'
      end
    end
  end
end
