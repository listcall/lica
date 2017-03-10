# new_pgr

require 'spec_helper'
require 'pgr/send/phone/base'

require_relative '../base_shared'

describe Pgr::Send::Phone::Base do

  klas    { described_class  }
  subject { klas.new         }

  it_behaves_like 'send/base'

  describe '.proxy_class' do
    specify { expect(kp('development')).to eq Pgr::Send::Phone::Proxy::SmsOpener }
    specify { expect(kp('dev_live')).to    eq Pgr::Send::Phone::Proxy::Plivo     }
    specify { expect(kp('production')).to  eq Pgr::Send::Phone::Proxy::Plivo     }
    specify { expect(kp('test')).to        eq Pgr::Send::Phone::Proxy::NoOp      }
  end
end