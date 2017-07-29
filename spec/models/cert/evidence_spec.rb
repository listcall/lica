require 'rails_helper'

describe Cert::Evidence do  #
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
    it { should respond_to :user             }
    it { should respond_to :cert_assignments }
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
# Table name: cert_evidence
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  comment                   :string
#  link                      :string
#  attachment_file_name      :string
#  attachment_file_size      :string
#  attachment_content_type   :string
#  attachment_updated_at     :string
#  expires_at                :datetime
#  ninety_day_notice_sent_at :datetime
#  thirty_day_notice_sent_at :datetime
#  expired_notice_sent_at    :datetime
#  xfields                   :hstore           default({})
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
