require 'rails_helper'

describe MembershipCert do
  let(:klas) { described_class }
  subject    { klas.new(title: 'HO')        }

  describe 'Creation' do
    specify { expect(subject).to be_valid        }
    specify { expect(subject.save).to be_truthy  }
  end

  describe 'Attributes' do
    it { should respond_to(:membership_id) }
    it { should respond_to(:qual_ctype_id) }
    it { should respond_to(:position)      }
    it { should respond_to(:status)        }
    it { should respond_to(:xfields)       }
  end

  describe 'Associations' do
    it { should respond_to(:membership) }
    it { should respond_to(:user_cert)  }
    it { should respond_to(:qual_ctype) }
    it { should respond_to(:ctype)      }
  end
end

# == Schema Information
#
# Table name: membership_certs
#
#  id            :integer          not null, primary key
#  membership_id :integer
#  qual_ctype_id :integer
#  position      :integer
#  user_cert_id  :integer
#  status        :string(255)
#  reviewer_id   :integer
#  reviewed_at   :string(255)
#  external_id   :string(255)
#  xfields       :hstore           default({})
#  created_at    :datetime
#  updated_at    :datetime
#  title         :string(255)
#  mc_expires_at :datetime
#  ev_type       :string(255)
#
