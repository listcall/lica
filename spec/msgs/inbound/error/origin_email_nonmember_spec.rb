# new_pgr

require          'rails_helper'
require_relative '../handler_shared'

describe Inbound::Error::OriginPhoneNonmember do

  let(:klas) { described_class }
  subject    { klas.new        }

  it_behaves_like 'a handler'

end