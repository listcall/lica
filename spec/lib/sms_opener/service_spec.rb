require 'spec_helper'
require 'sms_opener/base'

describe 'SmsOpener::Service' do

  def valid_params
    {
      fm:   '16502342344',
      to:   '14084324323',
      fqdn: 'qwer.asdf.com',
      text: 'TBD'
    }
  end

  before(:each) do
    @obj = SmsOpener::Service.new(valid_params)
  end

  describe '#initialize' do
    specify { expect(@obj).to respond_to(:deliver) }
  end

  describe '#deliver' do

    it 'launches the display' do
      expect(@obj).to receive(:launch)
      @obj.deliver
    end

  end

end