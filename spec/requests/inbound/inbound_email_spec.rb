require 'rails_helper'

describe 'Inbound Letter Opener' do

  include_context 'Integration Environment'

  def inbound_params
    {
      inbound:
        {
          'from'        => email1,
          'subject'     => 'PAGE 10-03 13:26:08',
          'to'          => mmail2,
          'text'        => 'TBD',
        }
    }
  end

  def reply_params
    {
      'from'        => 'andy@r210.com',
      'In-Reply-To' => '<pgr-35-22@test1.listcall.net>',
      'Message-ID'  => '<msg-132608@opnletter.org>',
      'subject'     => 'Re: PAGE 10-03 13:26:08',
      'to'          => 'pager@test1.listcall.net',
      'text'        => 'incoming!!',
    }
  end

  def invalid_reply_params
    reply_params.merge({'In-Reply-To' => '<invalid_id@test1.listcall.net'})
  end

  # describe 'single-team member page' do
  #   it 'generates one pager assignment' do
  #     post "#{team1_url}/inbound/email/letter_opener", params: inbound_params
  #     expect(Pgr::Assignment.count).to eq 1
  #     expect(Pgr::Broadcast.count).to  eq 1
  #     expect(Pgr::Outbound.count).to   eq 4
  #   end
  # end

  # describe 'multi-team member page' do
  #   it 'generates two pager assignments' do
  #     parms = inbound_params.merge({'to' => mmail3})
  #     post "#{team1_url}/inbound/email/letter_opener", parms
  #     expect(Pgr::Assignment.count).to eq 1  # TODO: should be 2, not 1 !!
  #     expect(Pgr::Broadcast.count).to  eq 1
  #     expect(Pgr::Outbound.count).to   eq 4
  #   end

  #   it 'generates three pager assignments' do
  #     parms = inbound_params.merge({'from' => email1, 'to' => "#{mmail2}, #{mmail3}"})
  #     post "#{team2_url}/inbound/email/letter_opener", parms
  #     expect(Pgr::Assignment.count).to eq 0   # TODO: this is broken!
  #     expect(Pgr::Broadcast.count).to  eq 0   # TODO: this is broken!
  #     expect(Pgr::Outbound.count).to   eq 0   # TODO: this is broken!
  #   end
  # end

  # describe 'single-team role page' do
  #   it 'generates one pager assignment' do
  #     mem2.roles << 'SEC'; mem2.save;
  #     parms = inbound_params.merge({'from' => email1, 'to' => "sec@#{team1.fqdn}"})
  #     post "http://#{team1.fqdn}/inbound/email/letter_opener", parms
  #     expect(Pgr::Assignment.count).to eq 1
  #     expect(Pgr::Broadcast.count).to  eq 1
  #     expect(Pgr::Outbound.count).to   eq 4
  #   end
  # end
end
