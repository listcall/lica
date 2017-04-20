require 'rails_helper'
require 'ext/time'

feature 'Avail/Days', :capy do

  include_context 'Integration Environment'

  let(:indx_path) { '/avail/days'                      }
  let(:show_path) { "/avail/days/#{mem1.user_name}"    }

  before(:each) { set_feature_host(team1)                                }

  describe 'basic rendering' do
    context 'with generated user' do #.
      it 'renders indx_path' do
        capy_create_member_and_login team1
        visit indx_path
        expect(current_path).to eq(indx_path)
        expect(page.status_code).to be 200
        expect(page).not_to be_nil
      end
    end

    context 'with factory user' do
      it 'renders indx_path' do
        login_with mem1
        visit indx_path
        expect(page.status_code).to be 200
      end

      it 'renders show_path' do
        login_with mem1
        visit show_path
        expect(page.status_code).to be 200
      end
    end
  end
end