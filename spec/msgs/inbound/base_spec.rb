# new_pgr

require 'rails_helper'

describe Inbound::Base do

  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Attributes' do
    it { should respond_to :inbound    }
  end

  describe 'Instance Methods' do
    it { should respond_to :handle           }
    it { should respond_to :handler_class     }
  end
end