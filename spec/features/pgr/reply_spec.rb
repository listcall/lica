require 'rails_helper'

feature 'pgr#reply', :capy do

  let(:orgn) { FG.create(:org)                                            }
  let(:team) { FG.create(:team, org_id: orgn.id)                          }
  let(:pagr) { Pgr.find_or_create_by(team_id: team.id)                    }
  let(:usr1) { FG.create(:user_with_phone_and_email)                      }
  let(:usr2) { FG.create(:user_with_phone_and_email)                      }
  let(:mem1) { FG.create(:membership, team_id: team.id, user_id: usr1.id) }
  let(:mem2) { FG.create(:membership, team_id: team.id, user_id: usr2.id) }

  describe 'page replies' do #
    before(:each) do
      set_host_url(team, orgn)
      @pager                = pagr
      bcst_params = {
        assignments_attributes: [{'pgr_id' => pagr.id}],
        recipient_ids: [mem2.id],
        short_body:    'asdf',
        sender_id:     mem1.id,
        email:         'on',
        phone:         'on'
      }
      @broadcast = Pgr::Broadcast::AsPagingCreate.create(bcst_params)
      Pgr::Util::GenBroadcast.new(@broadcast).generate_all.deliver_all
      @assign    = @broadcast.assignments[0]
    end

    context 'basic setup' do
      it 'generates the right number of objects' do
        expect(Team.count).to eq(1)
        expect(Pgr.count).to eq(1)
        expect(Pgr::Assignment.count).to eq(1)
        expect(Pgr::Broadcast.count).to eq(1)
        expect(Pgr::Dialog.count).to eq(1)
        expect(Pgr::Post.count).to eq(1)
        expect(Pgr::Outbound.count).to eq(4)
      end

      it 'renders the broadcast page' do
        login_with mem1
        visit "/paging/#{@assign.sequential_id}"
        expect(page.status_code).to be 200
      end

      it 'renders the dialog page' do
        login_with mem1
        visit "/paging/#{@assign.sequential_id}/for/#{@broadcast.dialogs.first.id}"
        expect(page.status_code).to be 200
      end
    end

    context 'with one reply' do
      before(:each) do
        login_with mem1
        @url = "/paging/#{@assign.sequential_id}/for/#{@broadcast.dialogs.first.id}"
        visit @url
        fill_in 'inputText', :with => 'text'
        click_button 'Send'
      end

      it 'generates the right number of objects' do
        expect(Pgr::Broadcast.count).to eq(1)
        expect(Pgr::Dialog.count).to eq(1)
        expect(Pgr::Post.count).to eq(2)
        expect(Pgr::Outbound.count).to eq(5)
      end

      it 'navigates to the right page' do
        expect(current_path).to eq(@url)
        expect(page.status_code).to be 200
      end
    end
  end
end
