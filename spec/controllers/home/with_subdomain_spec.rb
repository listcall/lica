require 'rails_helper'

# noinspection RubyArgCount
describe HomeController, 'with a subdomain' do

  before(:each) do
    @orgn = FG.create(:org)
    @team  = FG.create(:team, org_id: @orgn.id)
    Team.current_id   = @team .id
    request.host      = "#{@team .subdomain}.#{@orgn.domain}"
  end

  context 'as a public user' do
    describe 'GET index' do
      it 'has appropriate current-object values' do
        get :index
        expect(controller.current_team).to eq(@team)
        expect(controller.current_user).to    be_nil
        expect(controller.current_membership).to  be_nil
      end

      it 'redirects to /login' do
        get :index
        expect(response).to redirect_to '/login'
      end
    end
  end

  context 'as a logged-in non-member' do

    before(:each) do
      @user = FG.create(:user)
      session[:user_id] = @user.id
    end

    describe 'Get index' do
      it 'has appropriate current-object values' do
        get :index
        expect(controller.current_user).to eq(@user)
        expect(controller.current_team).to eq(@team)
        expect(controller.current_membership).to be_nil
      end

      it 'redirects to /info/no_access' do
        get :index
        expect(response).to redirect_to '/info/no_access'
      end
    end
  end

  context 'as a logged-in active member' do

    before(:each) do
      @user = FG.create(:user)
      session[:user_id] = @user.id
      @membership = FG.create(:membership, user_id: @user.id, team_id: @team .id)
    end

    describe 'Get index' do

      it 'has appropriate current-object values' do
        get :index
        expect(controller.current_user).to        eq(@user)
        expect(controller.current_team).to        eq(@team)
        expect(controller.current_membership).to  eq(@membership)
      end

      it "renders /home/index" do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end
end