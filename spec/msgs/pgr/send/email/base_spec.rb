# new_pgr

require 'spec_helper'
require 'pgr/send/email/base'

require_relative '../base_shared'

describe Pgr::Send::Email::Base do

  let(:klas)  { described_class  }
  subject     { klas.new         }

  it_behaves_like 'send/base'

  describe '.proxy_class' do
    specify { expect(kp('development')).to eq Pgr::Send::Email::Proxy::PgrMailer }
    specify { expect(kp('dev_live')).to    eq Pgr::Send::Email::Proxy::Mailgun   }
    specify { expect(kp('production')).to  eq Pgr::Send::Email::Proxy::Mailgun   }
    specify { expect(kp('test')).to        eq Pgr::Send::Email::Proxy::NoOp      }
  end
end