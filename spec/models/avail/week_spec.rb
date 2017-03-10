require 'rails_helper'

describe Avail::Week do
  let(:klas)        { described_class          }
  let(:base_params) { {}                       }
  let(:subject)     { klas.new(base_params)    }

  describe 'Attributes' do
    it { should respond_to :team_id            }
    it { should respond_to :membership_id      }
    it { should respond_to :status             }
    it { should respond_to :comment            }
    it { should respond_to :year               }
    it { should respond_to :quarter            }
    it { should respond_to :week               }
  end

  describe 'Associations' do
    it { should respond_to :team               }
    it { should respond_to :membership         }
  end

  describe 'Object Creation' do
    it 'handles object creation' do
      expect(subject).to be_valid
    end

    it 'saves the object to the database' do
      subject.save
      expect(subject).to be_valid
    end
  end
end

# == Schema Information
#
# Table name: avail_weeks
#
#  id            :integer          not null, primary key
#  team_id       :integer
#  membership_id :integer
#  year          :integer
#  quarter       :integer
#  week          :integer
#  status        :string(255)
#  comment       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
