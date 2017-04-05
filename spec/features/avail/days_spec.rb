require 'rails_helper'
require 'ext/time'

feature 'Avail/Days', :capy do
  let(:orgn) { FG.create(:org)                                            }
  let(:team) { FG.create(:team, org_id: orgn.id)                          }
  let(:usr1) { FG.create(:user_with_phone_and_email)                      }
  let(:usr2) { FG.create(:user_with_phone_and_email)                      }
  let(:mem1) { FG.create(:membership, team_id: team.id, user_id: usr1.id) }
  let(:mem2) { FG.create(:membership, team_id: team.id, user_id: usr2.id) }

  let(:indx_path) { '/avail/days'                      }
  let(:show_path) { "/avail/days/#{mem1.user_name}"    }

  before(:each) { set_host_url(team, orgn)                                }

  describe 'basic rendering' do
    context 'with generated user' do #
      it 'renders indx_path' do
        capy_create_member_and_login team
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