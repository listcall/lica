require 'spec_helper'
require 'sms_opener/base'

describe 'SmsOpener::Message' do

  def valid_params
    {
      fm:   '16502342344',
      to:   '14084324323',
      text: 'TBD',
      fqdn: 'asdf.qwer.com'
    }
  end

  before(:each) do
    @obj = SmsOpener::Message.new(valid_params)
  end

  describe '#initialize' do
    specify { expect(@obj).to respond_to(:render_msg) }
  end

  describe '#render' do
    specify { expect(@obj.render_msg).not_to be_nil   }
    specify { expect(@obj.render_msg).to be_a(String) }
  end

end