# new_pgr

require 'spec_helper'
require 'pgr/send/email/proxy/no_op'

require_relative '../../proxy_shared'

describe Pgr::Send::Email::Proxy::NoOp do

  let(:klas) { described_class  }
  subject    { klas.new         }

  it_behaves_like 'a sender proxy'

end