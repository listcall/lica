require 'rails_helper'

describe 'Home', :capy do

  include_context 'Integration Environment'

  before(:each) { set_feature_host(team1)          }

  context 'with a subdomain' do
    context 'as a public user' do
      HOME_PAGES.each do |page|
        it 'renders /login' do
          visit "/home/#{page}"
          expect(current_path).to eq('/login')
          expect(page).not_to be_nil
        end
      end
    end
  end
end