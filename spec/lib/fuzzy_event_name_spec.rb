require 'spec_helper'
require 'fuzzy_event_name'

describe FuzzyEventName do

  describe 'object attributes' do
    let(:obj) { described_class.new }
    specify { expect(obj).to respond_to(:input) }
  end

end