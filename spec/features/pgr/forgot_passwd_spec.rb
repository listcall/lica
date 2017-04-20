require 'rails_helper'

feature '/forgot/password' do

  include_context "Integration Environment"

  describe 'page creation' do

    before(:each) do
      set_feature_host(team1)
    end

    it 'renders /forgot/password' do
      visit "password/forgot"
      expect(page.status_code).to be 200
    end
  end
end
