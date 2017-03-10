# new_pgr

require          'rails_helper'
require_relative '../handler_shared'

describe Inbound::Error::ClassBlank do

  let(:klas) { described_class }
  subject    { klas.new        }

  it_behaves_like 'a handler'

  describe '#handle' do
    it 'raises an error when called' do
      expect { subject.handle }.to raise_exception
    end
  end
end