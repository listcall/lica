# new_pgr

require 'spec_helper'
require 'pgr/send/email/proxy/letter_opener'

require_relative '../../proxy_shared'

describe Pgr::Send::Email::Proxy::LetterOpener do

  let(:klas) { described_class  }
  subject    { klas.new         }

  it_behaves_like 'a sender proxy'

  describe 'outbound opts' do

    def bcst_params
      {
        'email'         => true,
        'sender_id'     => 1,
        'short_body'    => 'Hello World',
        'long_body'     => 'Hello Long Body World',
        'recipient_ids' => []
      }
    end

    before(:each) do
      @org  = FG.create(:org)
      @team = FG.create(:team, org_id: @org.id)
      @pagr = Pgr.create team_id: @team.id
      @user = FG.create(:user_with_email)
      @memb = FG.create(:membership, team_id: @team.id, user_id: @user.id)
      @bcst = PagerBroadcastSvc.new(@pagr, bcst_params)
      @bcst.params['sender_id']     = @memb.id
      @bcst.params['recipient_ids'] = [@memb.id]
      @bcst.create
    end
  end
end