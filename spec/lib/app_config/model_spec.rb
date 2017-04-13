require          'spec_helper'
require_relative './_model_helper'

describe AppConfig::Model do

  def new_model(params = {})
    TestId.new params
  end

  def new_uuid_model(params={})
    TestUuid.new params
  end

  context 'without params' do

    before(:each) { @obj = new_model }

    it 'generates an object' do
      expect(@obj).not_to be_nil
    end

    describe 'Object Attributes' do
      specify { expect(@obj).to respond_to :field1   }
      specify { expect(@obj).to respond_to :field2   }
      specify { expect(@obj).to respond_to :errors=  }
    end

    describe 'Default Attributes' do
      specify { expect(@obj.field1).not_to be_nil }
      specify { expect(@obj.field1).to     be_a String }
      specify { expect(@obj.field2).not_to be_nil }
      specify { expect(@obj.field2).to     be_a String }
    end

    describe 'Inherited Object Attributes' do
      specify { expect(@obj).to respond_to :position }
    end

    describe 'Object Methods' do
      specify { expect(@obj).to respond_to :id     }
      specify { expect(@obj).to respond_to :to_h   }
    end

  end

  context 'with params' do

    def valid_params
      {
          field1:   'x',
          field2:   'y'
      }
    end

    let(:obj) { new_model(valid_params) }

    it 'creates a valid object' do
      expect(obj).not_to be_nil
      expect(obj).to be_valid
    end

    it 'returns valid instance variables' do
      expect(obj.field1).to eq(valid_params[:field1])
      expect(obj.field2).to eq(valid_params[:field2])
    end

    describe '#id' do

      it 'matches the ID field' do
        expect(obj.id).to eq(obj.field1)
      end

    end

    describe '#to_h' do

      it 'matches the input params' do
        expect(obj.to_h).to eq(valid_params.merge({position: 0, field1: valid_params[:field1]}))
      end

    end

  end

  context 'using UUID' do
    before(:each) { @obj = new_uuid_model }

    it 'generates an object' do
      expect(@obj).not_to be_nil
    end

    describe 'Object Attributes' do
      specify { expect(@obj).to respond_to :id       }
      specify { expect(@obj).to respond_to :uuid     }
      specify { expect(@obj).to respond_to :field1   }
      specify { expect(@obj).to respond_to :field2   }
      specify { expect(@obj.id).to be_a String  }
      specify { expect(@obj.id).to eq(@obj.uuid) }
    end

  end

end
