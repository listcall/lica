require 'rails_helper'

describe 'Home', :capy do

  let(:orgn) { FG.create(:org)                    }
  let(:team) { FG.create(:team, org: orgn)        }

  before(:each) { set_host_url(team, orgn)        }

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