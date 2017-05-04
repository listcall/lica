require 'rails_helper'

feature '/paging'  do #

  include_context "Integration Environment"

  describe 'page rendering' do

    before(:each) do
      set_feature_host(team1)
      expect(pagr1).to be_present
    end

    it 'renders /paging' do
      capy_create_member_and_login team1
      visit '/paging'
      expect(current_path).to eq('/paging')
      expect(page.status_code).to be 200
      expect(page).not_to be_nil
    end
  end
end