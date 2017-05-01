require 'rails_helper'
require 'rq_broadcasts'

describe 'Pager Forwarding', :focus do

  include_context 'Integration Environment'

  let(:req) { RqBroadcasts.new }

  describe 'sending and forwarding' do

    before(:each) { hydrate(mem1, mem2); request_login(mem1) }

    it 'handles a single message' do
      post "/paging", params: req.paging_mail_opts(mem1, mem2)
      expect(Pgr::Broadcast.count).to        eq(1)
      expect(Pgr::Dialog.count).to           eq(1)
      expect(Pgr::Post.count).to             eq(1)
      expect(Pgr::Outbound.count).to         eq(2)
      expect(Pgr::Outbound.pending.count).to eq(0)
      expect(Inbound.count).to               eq(0)
    end

    it 'handles a web followup' do
      post "/paging", params: req.paging_mail_opts(mem1, mem2)
      post "/paging/#{req.assignment_sid}", params: req.web_followup_opts(mem2)
      expect(Pgr::Broadcast.count).to        eq(1)
      expect(Pgr::Dialog.count).to           eq(1)
      expect(Pgr::Post.count).to             eq(1)
      expect(Pgr::Post::StiMsg.count).to     eq(1)
      expect(Pgr::Post::StiAction.count).to  eq(0)
      expect(Pgr::Outbound.count).to         eq(2)
      expect(Pgr::Outbound.pending.count).to eq(0)
      expect(Inbound.count).to               eq(0)
    end
  end
end
