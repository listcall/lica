require 'rails_helper'
require 'rq_broadcasts'

describe 'Pager Interaction', :focus do

  include_context 'Integration Environment'

  let(:req) { RqBroadcasts.new }

  describe 'sending pages' do

    before(:each) { hydrate(mem1, mem2); request_login(mem1) }

    # it 'handles a single message' do
    #   post '/paging', params: req.paging_mail_opts(mem1, mem2)
    #   expect(Pgr::Broadcast.count).to        eq(1)
    #   expect(Pgr::Dialog.count).to           eq(1)
    #   expect(Pgr::Post.count).to             eq(1)
    #   expect(Pgr::Outbound.count).to         eq(2)
    #   expect(Pgr::Outbound.pending.count).to eq(0)
    #   expect(Inbound.count).to               eq(0)
    # end
    #
    # it 'handles an email reply' do
    #   post '/paging', params: req.paging_mail_opts(mem1, mem2)
    #   post '/letter_opener_reply', params: req.mail_reply_opts(mem2, team1)
    #   expect(Pgr::Broadcast.count).to        eq(1)
    #   expect(Pgr::Dialog.count).to           eq(1)
    #   expect(Pgr::Post.count).to             eq(3)
    #   expect(Pgr::Outbound.count).to         eq(2)
    #   expect(Pgr::Outbound.pending.count).to eq(0)
    #   expect(Inbound.count).to               eq(1)
    # end
    #
    # it 'handles a web reply' do
    #   post '/paging', params: req.paging_mail_opts(mem1, mem2)
    #   post '/letter_opener_reply', params: req.mail_reply_opts(mem2, team1)
    #   post "/paging/#{req.broadcast_id}/for/#{req.dialog_id}", params: req.web_reply_opts(mem1)
    #   expect(Pgr::Broadcast.count).to        eq(1)
    #   expect(Pgr::Dialog.count).to           eq(1)
    #   expect(Pgr::Post.count).to             eq(4)
    #   expect(Pgr::Post::StiMsg.count).to     eq(3)
    #   expect(Pgr::Post::StiAction.count).to  eq(1)
    #   expect(Pgr::Outbound.count).to         eq(3)
    #   expect(Pgr::Outbound.pending.count).to eq(0)
    #   expect(Inbound.count).to               eq(1)
    # end
  end
end
