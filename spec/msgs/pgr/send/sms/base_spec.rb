# new_pgr

require 'spec_helper'
require 'pgr/send/sms/base'

require_relative '../base_shared'

describe Pgr::Send::Sms::Base do

  klas    { described_class  }
  subject { klas.new         }

  it_behaves_like 'send/base'

  describe '.proxy_class' do
    specify { expect(kp('development')).to eq Pgr::Send::Sms::Proxy::SmsOpener }
    specify { expect(kp('dev_live')).to    eq Pgr::Send::Sms::Proxy::Plivo     }
    specify { expect(kp('production')).to  eq Pgr::Send::Sms::Proxy::Plivo     }
    specify { expect(kp('test')).to        eq Pgr::Send::Sms::Proxy::NoOp      }
  end
end