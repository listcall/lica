require 'rails_helper'

feature '/paging'  do

  let(:orgn) { FG.create(:org)                                            }
  let(:team) { FG.create(:team, org_id: orgn.id)                          }
  let(:pagr) { Pgr.create(team_id: team.id)                               }
  let(:usr1) { FG.create(:user_with_phone_and_email)                      }
  let(:usr2) { FG.create(:user_with_phone_and_email)                      }
  let(:mem1) { FG.create(:membership, team_id: team.id, user_id: usr1.id) }
  let(:mem2) { FG.create(:membership, team_id: team.id, user_id: usr2.id) }

  describe 'page rendering' do

    before(:each) do
      set_host_url(team, orgn)
      expect(pagr).to be_present
    end

    it 'renders /paging' do
      capy_create_member_and_login team
      visit '/paging'
      expect(current_path).to eq('/paging')
      expect(page.status_code).to be 200
      expect(page).not_to be_nil
    end
  end
end