require 'rails_helper'

describe MemberRanks do

  def new_member_rank
    FG.build :member_rank
  end

  context 'basic object creation' do

    before(:each) { @obj = MemberRanks.new }

    it 'works' do
      expect(@obj).not_to be_nil
    end

    describe 'object methods' do
      specify { expect(@obj).to respond_to :count       }
      specify { expect(@obj).to respond_to :to_h        }
      specify { expect(@obj).to respond_to :to_a        }
      specify { expect(@obj).to respond_to :create      } #
    end

    context 'with hash params' do
      def valid_params
        {
            label: 'fm',
            name: 'field member',
            description: 'operates in field',
            position: 1
        }
      end
      it 'works with one hash' do
        @obj = MemberRanks.new.add_data({a: valid_params})
        expect(@obj).not_to be_nil
      end
    end

  end

  describe '.[]' do
    before(:each) do
      @obj1 = FG.build :member_rank
      @obj2 = FG.build :member_rank
      @col  = MemberRanks.new.add_obj @obj1, @obj2
    end

    it 'returns the right object' do
      expect(@col[@obj1.id]).to eq(@obj1)
    end

    it 'returns nil with an invalid key' do
      expect(@col['unknown']).to eq(nil)
    end

  end

  describe '.count' do

    before(:each) { @col = MemberRanks.new }

    context 'with no objects' do
      specify { expect(@col.count).to eq(0) }
    end

    context 'with one object' do
      it 'returns count of one' do
        @col.set_obj(new_member_rank)
        expect(@col.count).to eq(1)
      end
    end

    context 'with two objects' do
      it 'returns count of two' do
        @col.set_obj(new_member_rank, new_member_rank)
        expect(@col.count).to eq(2)
      end
    end

    context 'after destroying an object' do
      it 'returns count of one' do
        mdl1 = new_member_rank
        mdl2 = new_member_rank
        @col.set_obj mdl1, mdl2
        @col.destroy mdl1
        expect(@col.count).to eq(1)
      end
    end

  end

  describe '.find' do

    before(:each) { @col = MemberRanks.new }

    context 'with no objects' do
      specify {expect(@col.find('asdf')).to be_nil}
    end

    context 'with two objects' do
      context 'when a key hits' do
        it 'returns an object' do
          mdl1 = new_member_rank
          @col.set_obj mdl1, new_member_rank
          expect(@col.find(mdl1.label)).to eq(mdl1)
        end
      end
      context 'when a key misses' do
        it 'returns nil' do
          @col.set_obj new_member_rank, new_member_rank
          expect(@col.find('asdf')).to be_nil
        end
      end
    end
  end

  describe '#to_a' do
    context 'with no objects' do
      specify {expect(MemberRanks.new.to_a).to be_a Array }
      specify {expect(MemberRanks.new.to_a.count).to eq(0) }
    end

    context 'with two objects' do
      before(:each) { @col = MemberRanks.new.set_obj new_member_rank, new_member_rank}
      it 'generates a valid array' do
        expect(@col.to_a).to be_an Array
        expect(@col.to_a.first).to be_a MemberRank
        expect(@col.to_a.length).to eq(2)
      end
    end
  end

  describe '#to_h' do
    context 'with no objects' do
      specify {expect(MemberRanks.new.to_h).to be_a Hash }
      specify {expect(MemberRanks.new.to_h.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = MemberRanks.new.set_obj new_member_rank, new_member_rank}
      it 'generates a valid hash' do
        result = @col.to_h
        expect(result).to be_a Hash
        expect(result[result.keys.first]).to be_a MemberRank
        expect(result.length).to eq(2)
      end
    end
  end

  describe '#to_data' do
    context 'with no objects' do
      specify {expect(MemberRanks.new.to_data).to be_a Hash }
      specify {expect(MemberRanks.new.to_data.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = MemberRanks.new.set_obj new_member_rank, new_member_rank}
      it 'generates a valid hash' do
        result = @col.to_data
        expect(result).to be_a Hash
        expect(result[result.keys.first]).to be_a Hash
        expect(result.length).to eq(2)
      end
    end

  end

end