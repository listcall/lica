require          'rails_helper'
require_relative '../handler_shared'

describe Inbound::Handler::PgrEmailNew do

  let(:klas) { described_class }

  it_behaves_like 'a handler'

  include_context "Integration Environment"

  let(:user1) { FG.create(:user_with_phone_and_email) }
  let(:user2) { FG.create(:user_with_phone_and_email) }
  let(:user3) { FG.create(:user_with_phone_and_email) }
  let(:recp1) { FG.create(:membership, team_id: team1.id, user_id: user2.id) }
  let(:recp2) { FG.create(:membership, team_id: team1.id, user_id: user3.id) }

  def inbound_params
    {
      team_id: team1.id,
      subject: 'Test',
      text:    'test input',
      fm:      user1.emails.first.address,
      to:      [pager_address(recp2)],
    }
  end

  let(:inbound) { Inbound::StiEmail.create(inbound_params)   }
  subject       { klas.new(inbound)                          }

  describe '#handle' do
    before(:each) { hydrate user1, recp2 }
    it 'generates a post and outbounds' do
      expect(Pgr::Post.count).to     eq(0)
      expect(Pgr::Outbound.count).to eq(0)
      subject.handle
      expect(Pgr::Post.count).to     eq(1)
      expect(Pgr::Outbound.count).to eq(4)
    end
  end
end