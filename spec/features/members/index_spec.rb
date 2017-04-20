require 'rails_helper'

feature 'members#index', :capy do

  include_context 'Integration Environment'

  describe 'page rendering' do
    before(:each) { set_feature_host(team1) }

    it 'renders /members' do
      capy_create_member_and_login team1
      visit '/members'
      expect(current_path).to eq('/members')
      expect(page.status_code).to be 200
      expect(page).not_to be_nil
      expect(page).to have_content('John')
    end
  end
end