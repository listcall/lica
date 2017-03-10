# new_pgr

require          'rails_helper'
require_relative '../handler_shared'

describe Inbound::Handler::ForumNew do

  let(:klas) { described_class }
  subject    { klas.new        }

  it_behaves_like 'a handler'

  describe 'Attributes' do
    # it { should respond_to :inbound    }
  end

  describe 'Instance Methods' do
    # it { should respond_to :handle           }
    # it { should respond_to :handler_class     }
  end
end