require 'rails_helper'

describe 'Ztst', :js do

  include_context 'Integration Environment'

  before(:each) do
    set_feature_host(team1)
    capy_create_member_and_login team1
  end

  context 'as a registered user' do
    (ZTST_PAGES).each do |page_name|
      it "renders #{page_name}" do
        tst_path = "/ztst/#{page_name}"
        visit tst_path
        expect(current_path).to eq(tst_path)
        expect(page).not_to be_nil
      end
    end
  end
end