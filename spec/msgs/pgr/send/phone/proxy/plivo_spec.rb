# new_pgr

require 'spec_helper'
require 'pgr/send/phone/proxy/plivo'

require_relative '../../proxy_shared'

describe Pgr::Send::Phone::Proxy::Plivo do

  klas    { described_class  }
  subject { klas.new         }

  it_behaves_like 'a sender proxy'

  describe "object creation" do
    it "returns an object" do
      expect(subject).to be_present
    end
  end
end