require 'rails_helper'

describe Qual do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Creation' do
    specify { expect(subject).to be_valid        }
    specify { expect(subject.save).to be_truthy  }
  end

  describe 'Attributes' do
    it { should respond_to :team_id }
    it { should respond_to :xfields }
    it { should respond_to :name    }
    it { should respond_to :rname   }
  end

  describe 'Associations' do
    it { should respond_to :team              }
    it { should respond_to :qual_partnerships }
    it { should respond_to :qual_assignments  }
  end

  describe '.defaults_for' do
    let(:arr) { klas.defaults_for(1) }
    let(:obj) { arr.first }
    specify { expect(arr).to        be_present   }
    specify { expect(arr).to        be_an(Array) }
    specify { expect(arr.length).to eq(1)        }
    specify { expect(obj).to        be_a(klas)   }
    specify { expect(obj).to        be_valid     }
  end
end

# == Schema Information
#
# Table name: quals
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  name       :string(255)
#  rname      :string(255)
#  position   :integer
#  xfields    :hstore           default({})
#  created_at :datetime
#  updated_at :datetime
#
