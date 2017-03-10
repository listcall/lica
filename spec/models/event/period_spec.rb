require 'rails_helper'

describe Event::Period do

  def valid_params
    {
      event_id: 1
    }
  end

  let(:klas) { described_class        }
  subject    { klas.new(valid_params) }

  describe 'Object Attributes' do
    it { should respond_to(:event_id)     }
    it { should respond_to(:position)     }
  end

  describe 'Associations' do
    it { should respond_to(:event)          }
    it { should respond_to(:participants)   }
    it { should respond_to(:reports)        }
  end

  describe 'Instance Methods' do
    it { should respond_to(:check_position) }
    it { should respond_to(:period_ref)     }
  end

  describe 'Validations' do
    it { should validate_presence_of(:event_id)  }
    it { should be_valid                         }
  end

  describe '#participants' do
    it 'lists participants' do
      expect(subject.participants.length).to eq(0)
    end

    it 'creates participants' do
      subject.save
      subject.participants.create
      expect(subject.participants.length).to eq(1)
    end
  end

  describe '#add_participant' do
    it 'adds a participant' do
      subject.save
      expect(subject.participants.count).to eq(0)
      subject.add_participant(1)
      expect(subject.participants.count).to eq(1)
    end
  end
end

# == Schema Information
#
# Table name: event_periods
#
#  id          :integer          not null, primary key
#  event_id    :integer
#  position    :integer
#  location    :string(255)
#  start       :datetime
#  finish      :datetime
#  external_id :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  ancestry    :string(255)
#
