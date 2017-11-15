require 'rails_helper'

describe Cert::Profile do
  let(:klas)        { described_class          }
  let(:base_params) { {}                       }
  let(:subject)     { klas.new(base_params)    }

  describe 'Attributes' do
    # it { should respond_to :team_id            }
    # it { should respond_to :membership_id      }
    # it { should respond_to :status             }
    # it { should respond_to :comment            }
    # it { should respond_to :year               }
    # it { should respond_to :quarter            }
    # it { should respond_to :week               }
  end

  describe 'Associations' do
    it { should respond_to :membership          }
    it { should respond_to :cert_fact           }
    it { should respond_to :cert_def    }
  end

  # describe 'Object Creation' do
  #   it 'handles object creation' do
  #   it 'handles object creation' do
  #     expect(subject).to be_valid
  #   end
  #
  #   it 'saves the object to the database' do
  #     subject.save
  #     expect(subject).to be_valid
  #   end
  # end
end

# == Schema Information
#
# Table name: cert_profiles
#
#  id            :integer          not null, primary key
#  membership_id :integer
#  cert_def_id   :integer
#  cert_fact_id  :integer
#  title         :string
#  position      :integer
#  status        :string
#  ev_type       :string
#  reviewer_id   :integer
#  reviewed_at   :string
#  external_id   :string
#  xfields       :hstore           default({})
#  mc_expires_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
