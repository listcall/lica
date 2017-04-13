require 'rails_helper'

feature 'members#index', :capy do
  let(:orgn) { FG.create(:org)                                            }
  let(:team) { FG.create(:team, org_id: orgn.id)                          }
  let(:usr1) { FG.create(:user_with_phone_and_email)                      }
  let(:usr2) { FG.create(:user_with_phone_and_email)                      }
  let(:mem1) { FG.create(:membership, team_id: team.id, user_id: usr1.id) }
  let(:mem2) { FG.create(:membership, team_id: team.id, user_id: usr2.id) }

  describe 'page rendering' do
    before(:each) { set_host_url(team, orgn) }

    it 'renders /members' do
      capy_create_member_and_login team
      visit '/members'
      expect(current_path).to eq('/members')
      expect(page.status_code).to be 200
      expect(page).not_to be_nil
      expect(page).to have_content('John')
    end
  end
end