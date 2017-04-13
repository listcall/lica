require          'spec_helper'
require_relative './_collection_helper'

describe AppConfig::Collection do

  def new_model
    TestUuid.new
  end

  def new_collection
    TestUuids.new
  end

  context 'basic object creation' do

    subject { new_collection }

    it 'works' do
      expect(subject).not_to be_nil
    end

    describe 'object methods' do
      it { should respond_to :count       }
      it { should respond_to :to_h        }
      it { should respond_to :to_a        }
      it { should respond_to :create      }
    end

    context 'with hash params' do
      def valid_params
        {
            field1: 'x',
            field2: 'y'
        }
      end
      it 'works with one hash' do
        @obj = new_collection.add_data({a: valid_params})
        expect(@obj.count).to eq(1)
        expect(@obj).not_to be_nil
      end
      it 'works with two hashes' do
        @obj = new_collection.add_data({a: valid_params, b: valid_params.merge({field1: 'asdf'})})
        expect(@obj.count).to eq(2)
        expect(@obj).not_to be_nil
      end
    end

  end

  describe '.[]' do
    before(:each) do
      @obj1 = new_model
      @col  = new_collection.add_obj @obj1
    end

    it 'returns the right object' do
      expect(@col[@obj1.id]).to eq(@obj1)
    end

    it 'returns nil with an invalid key' do
      expect(@col['unknown']).to eq(nil)
    end

  end

  describe '.count' do

    before(:each) { @col = new_collection }

    context 'with no objects' do
      specify { expect(@col.count).to eq(0) }
    end

    context 'with one object' do
      it 'returns count of one' do
        @col.add_obj(new_model)
        expect(@col.count).to eq(1)
      end
    end

    context 'with two objects' do
      it 'returns count of two' do
        @col.add_obj(new_model, new_model)
        expect(@col.count).to eq(2)
      end
    end

    context 'after destroying an object' do
      it 'returns count of one' do
        mdl1 = new_model
        mdl2 = new_model
        @col.add_obj mdl1, mdl2
        @col.destroy mdl1
        expect(@col.count).to eq(1)
      end
    end

  end

  describe '.find' do

    before(:each) { @col = new_collection }

    context 'with no objects' do
      specify {expect(@col.find('asdf')).to be_nil}
    end

    context 'with two objects' do
      context 'when a key hits' do
        it 'returns an object' do
          mdl1 = new_model
          @col.add_obj mdl1, new_model
          expect(@col.find(mdl1.id)).to eq(mdl1)
        end
      end
      context 'when a key misses' do
        it 'returns nil' do
          @col.add_obj new_model, new_model
          expect(@col.find('asdf')).to be_nil
        end
      end
    end
  end

  describe '.locate' do

    before(:each) { @col = new_collection }

    context 'with no objects' do
      specify {expect(@col.locate('asdf', 'qwer')).to be_nil}
    end

    context 'with two objects' do
      before(:each) { @col.add_obj new_model, new_model }
      context 'with an invalid attribute' do
        specify {expect(@col.locate('asdf', 'qwer')).to be_nil}
      end
      context 'with a valid attribute' do
        context 'when a value hits' do
          it 'returns an object' do
            expect(@col.locate('field1', 'asdf')).not_to be_nil
          end
        end
        context 'when a value misses' do
          it 'returns nil' do
            expect(@col.locate('field1', 'zzz')).to be_nil
          end
        end
      end
    end
  end

  describe '#to_a' do
    context 'with no objects' do
      specify {expect(new_collection.to_a).to be_a Array }
      specify {expect(new_collection.to_a.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = new_collection.add_obj new_model, new_model}
      it 'generates a valid array' do
        expect(@col.to_a).to be_an Array
        expect(@col.to_a.first).to be_a AppConfig::Model
        expect(@col.to_a.length).to eq(2)
      end
    end
  end

  describe '#to_h' do
    context 'with no objects' do
      specify {expect(new_collection.to_h).to be_a Hash }
      specify {expect(new_collection.to_h.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = new_collection.add_obj new_model, new_model}
      it 'generates a valid hash' do
        result = @col.to_h
        expect(result).to be_a Hash
        expect(result[result.keys.first]).to be_a AppConfig::Model
        expect(result.length).to eq(2)
      end
    end
  end

  describe '#to_data' do
    context 'with no objects' do
      specify {expect(new_collection.to_data).to be_a Hash }
      specify {expect(new_collection.to_data.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = new_collection.add_obj new_model, new_model}
      it 'generates a valid hash' do
        result = @col.to_data
        expect(result).to be_a Hash
        expect(result[result.keys.first]).to be_a Hash
        expect(result.length).to eq(2)
      end
    end

  end

end