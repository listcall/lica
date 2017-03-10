# new_pgr

require 'spec_helper'
require 'pgr/send/phone/proxy/no_op'

require_relative '../../proxy_shared'

describe Pgr::Send::Phone::Proxy::NoOp do

  klas    { described_class  }
  subject { klas.new         }

  it_behaves_like 'a sender proxy'

end