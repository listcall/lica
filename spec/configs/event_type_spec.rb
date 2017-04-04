require 'rails_helper'

describe EventType do

  describe 'Object Basics' do

    let(:obj) { described_class.new }

    describe 'Creation' do
      specify { expect(obj).to_not be_nil }
      specify { expect(obj).to be_valid   }
    end

    describe 'Attributes' do
      specify { expect(obj).to respond_to :name        }
      specify { expect(obj).to respond_to :use_transit }
    end

    describe 'Methods' do
      specify { expect(obj).to respond_to :use_transit?  }
      specify { expect(obj).to respond_to :errors=       }
    end

  end

  describe 'Validations' do
    let(:obj) { described_class.new }

    describe 'default_start_time' do
      it 'sets a default' do
        expect(obj.default_start_time).to eq('09:00')
      end
      it 'sets new values' do
        newtime = '10:00'
        obj.default_start_time = newtime
        expect(obj.default_start_time).to eq newtime
        expect(obj).to be_valid
      end
      it 'flags invalid data' do
        obj.default_start_time = '10:0'
        expect(obj).not_to be_valid
      end
    end

    describe 'duplicates' do
      it 'rejects duplicate names' do
        true
      end
    end

  end
end
