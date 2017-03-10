require 'rails_helper'

describe Pgr::Action do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Associations' do
    it { should respond_to :broadcast             }
  end

  describe 'Class Methods' do
    specify { expect(klas).to respond_to :enabled      }
    specify { expect(klas).to respond_to :label        }
    specify { expect(klas).to respond_to :about        }
    specify { expect(klas).to respond_to :usage_ctxt   }
    specify { expect(klas).to respond_to :has_period   }
    specify { expect(klas).to respond_to :profile      }
    specify { expect(klas).to respond_to :option_list  }
  end

  describe '.profile' do
    it 'returns a value' do
      val = klas.profile
      expect(val).to_not eq(nil)
    end
  end

  describe '.option_list' do
    it 'returns a value' do
      val = klas.option_list
      expect(val).to be_an(Array)
      expect(val.length).to eq(4)
      expect(val.to_json).to be_a(String)
    end
  end
end

# == Schema Information
#
# Table name: pgr_actions
#
#  id               :integer          not null, primary key
#  pgr_broadcast_id :integer
#  type             :string
#  xfields          :hstore           default("")
#  created_at       :datetime
#  updated_at       :datetime
#
