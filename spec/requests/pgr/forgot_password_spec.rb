require 'rails_helper'
require 'rq_broadcasts'

describe 'Forgot Password', :focus do

  include_context 'Integration Environment'

  let(:req) { RqBroadcasts.new }

  describe 'sending pages' do

    before(:each) { hydrate(mem1, mmail1, email1); set_request_host(team1)}

    it 'renders the forgot page' do  #....
      get "/password/forgot"
      expect(path).to eq('/password/forgot')
      expect(response.status).to eq(200)
    end

    it 'handles a password reset with invalid email' do
      post '/password/send_email', params: {email: mmail1}
      expect(response.status).to eq(200)
      expect(Pgr::Assignment.count).to       eq(0)
      expect(Pgr::Broadcast.count).to        eq(0)
      expect(Pgr::Dialog.count).to           eq(0)
      expect(Pgr::Post.count).to             eq(0)
      expect(Pgr::Outbound.count).to         eq(0)
      expect(Pgr::Outbound.pending.count).to eq(0)
      expect(Inbound.count).to               eq(0)
    end

    it 'handles a password reset with valid email' do
      post '/password/send_email', params: {email: email1}
      expect(response.status).to eq(302)
      expect(Pgr::Assignment.count).to       eq(0)
      expect(Pgr::Broadcast.count).to        eq(1)
      expect(Pgr::Dialog.count).to           eq(1)
      expect(Pgr::Post.count).to             eq(2)
      expect(Pgr::Outbound.count).to         eq(2)
      expect(Pgr::Outbound.pending.count).to eq(0)
      expect(Inbound.count).to               eq(0)
    end
  end
end
