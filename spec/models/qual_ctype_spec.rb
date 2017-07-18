require 'rails_helper'

describe QualCtype do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Creation' do
    specify { expect(subject).to be_valid        }
    specify { expect(subject.save).to be_truthy  }
  end

  describe 'Attributes' do
    specify { expect(subject).to respond_to(:team_id)     }
    specify { expect(subject).to respond_to(:xfields)     }
    specify { expect(subject).to respond_to(:name)        }
    specify { expect(subject).to respond_to(:rname)       }
    specify { expect(subject).to respond_to(:expirable)   }
    specify { expect(subject).to respond_to(:commentable) }
    specify { expect(subject).to respond_to(:ev_types)    }
  end

  describe 'Associations' do
    specify { expect(subject).to respond_to(:membership_certs)    }
    specify { expect(subject).to respond_to(:qual_assignments)    }
  end

  describe '.defaults_for' do
    let(:arr) { klas.defaults_for(1, 2) }
    let(:obj) { arr.first }
    specify { expect(arr).to        be_present   }
    specify { expect(arr).to        be_an(Array) }
    specify { expect(arr.length).to eq(1)        }
    specify { expect(obj).to        be_a(klas)   }
    specify { expect(obj).to        be_valid     }
  end

  describe '#title_select_method' do
    specify { expect(subject.title_select_method).to eq('free_text') }
    it 'accomodates changed values' do
      new_val = 'distinct_list'
      subject.title_select_method = new_val
      expect(subject.title_select_method).to eq(new_val)
    end
  end

end

# == Schema Information
#
# Table name: qual_ctypes
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string(255)
#  rname       :string(255)
#  expirable   :boolean          default(TRUE)
#  xfields     :hstore           default({})
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  ev_types    :text             default([]), is an Array
#  commentable :boolean          default(TRUE)
#
