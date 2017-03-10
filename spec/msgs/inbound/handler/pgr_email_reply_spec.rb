# new_pgr

require          'rails_helper'
require_relative '../handler_shared'

describe Inbound::Handler::PgrEmailReply do

  let(:klas) { described_class }

  it_behaves_like 'a handler'

  let(:team1) { FG.create(:team)                      }
  let(:pagr1) { Pgr.create(team_id: team1.id)         }
  let(:team2) { FG.create(:team)                      }
  let(:pagr2) { Pgr.create(team_id: team2.id)         }
  let(:user1) { FG.create(:user_with_phone_and_email) }
  let(:user2) { FG.create(:user_with_phone_and_email) }
  let(:user3) { FG.create(:user_with_phone_and_email) }
  let(:sendr) { FG.create(:membership, team_id: team1.id, user_id: user1.id) }
  let(:recp1) { FG.create(:membership, team_id: team1.id, user_id: user2.id) }
  let(:recp2) { FG.create(:membership, team_id: team1.id, user_id: user3.id) }
  let(:bcst) do
    bc = Pgr::Broadcast::AsPagingCreate.create(bcst_params)
    Pgr::Util::GenBroadcast.new(bc).generate_all.deliver_all
    bc
  end

  def bcst_params
    {
      'sender_id'              => sendr.id,
      'short_body'             => 'Hello World',
      'long_body'              => 'Hello Long Body World',
      'email'                  => true,
      'phone'                  => true,
      'recipient_ids'          => [recp1.id],
      'assignments_attributes' => [{'pgr_id' => pagr1.id}]
    }
  end

  def inbound_params
    {
      team_id: team1.id,
      subject: 're: Test',
      text:    'test reply',
      fm:      user1.emails.first.address,
      to:      ['pager@test.com'],
      headers: {'In-Reply-To' => "<pgr-#{bcst.dialogs.first.id}-1@test.com"}
    }
  end

  let(:inbound) { Inbound::StiEmail.create(inbound_params)   }
  subject       { klas.new(inbound)                          }

  describe '#handle' do
    it 'generates a post and outbounds' do
      expect(bcst).to_not be_nil
      expect(Pgr::Post.count).to     eq(1)
      expect(Pgr::Outbound.count).to eq(4)
      subject.handle
      expect(Pgr::Post.count).to     eq(2)
      expect(Pgr::Outbound.count).to eq(5)
    end
  end
end