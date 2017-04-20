require 'rails_helper'

feature 'quals#index'  do

  include_context "Integration Environment"

  describe 'page rendering' do

    before(:each) { set_feature_host(team1) }

    it 'renders /quals' do
      capy_create_member_and_login team1
      visit '/quals'
      expect(current_path).to eq('/quals')
      expect(page.status_code).to be 200
      expect(page).not_to be_nil
    end
  end
end