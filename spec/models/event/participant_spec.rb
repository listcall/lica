require 'rails_helper'

describe Event::Participant do

  def valid_params
    {
      # event_id: 1
    }
  end

  let(:klas) { described_class        }
  subject    { klas.new(valid_params) }

  describe 'Object Attributes' do
    it { should respond_to(:membership_id)       }
    it { should respond_to(:event_period_id)     }
  end

  describe 'Associations' do
    it { should respond_to(:period)        }
    it { should respond_to(:membership)    }
  end

  describe 'Instance Methods' do
    it { should respond_to(:transit_minutes)    }
    it { should respond_to(:signin_minutes)     }
  end

  describe 'Validations' do
    it { should validate_presence_of(:event_period_id)  }
  end
end

# == Schema Information
#
# Table name: event_participants
#
#  id              :integer          not null, primary key
#  membership_id   :integer
#  event_period_id :integer
#  role            :string(255)
#  comment         :string(255)
#  departed_at     :datetime
#  returned_at     :datetime
#  signed_in_at    :datetime
#  signed_out_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime
#
