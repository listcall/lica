require 'rails_helper'

describe Inbound::RouteMap, '#config' do

  let(:klas) { described_class     }
  subject    { klas.new            }

  before(:all) { load 'inbound/routes.rb' }

  def expect_handler_for(input, output)
    expect(klas.handler_for(input)).to eq(output)
  end

  describe 'error checks' do
    # specify { expect_handler_for nil        , Inbound::Error::ClassBlank       }
    specify { expect_handler_for 'BADKLAS'  , Inbound::Error::ClassInvalid     }
    specify { expect_handler_for Inbound.new, Inbound::Error::DestinationBlank }
  end

  describe 'destination blank' do ##
    let(:obj) { Inbound.new(to: 'asdf', fm: 'qwer') }
    specify { expect_handler_for obj, Inbound::Error::DestinationBlank   }
  end

  describe 'origin phone unrecognized' do
    let(:obj) { Inbound::StiSms.new(to: ['650-234-1234']) }
    specify { expect_handler_for obj, Inbound::Error::OriginSmsUnregistered }
  end

  describe 'origin email unrecognized' do
    let(:obj) { Inbound::StiEmail.new(to: ['pager@whatever.com']) }
    specify { expect_handler_for obj, Inbound::Error::OriginEmailUnregistered }
  end

  context 'valid matches' do
    let!(:team) { FG.create :team } #.
    let!(:usr1) { FG.create :user_with_email_and_phone }
    let!(:usr2) { FG.create :user_with_email_and_phone }
    let!(:mem1) { FG.create :membership, user: usr1, team: team }
    let!(:mem2) { FG.create :membership, user: usr2, team: team }
    let!(:eobj) { Inbound::StiEmail.new(team: team, fm: usr1.emails.first.address, to: [usr2.emails.first.address]) }

    specify { expect_handler_for eobj, Inbound::Handler::PgrEmailNew }
  end
end
