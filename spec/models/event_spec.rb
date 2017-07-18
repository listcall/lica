require 'rails_helper'

describe Event do

  def valid_params
    {
      typ:             'M',
      title:           'Test',
      location_name:   'TBD',
      start:           Time.now,
      finish:          Time.now,
    }
  end

  let(:klas) { described_class        }
  subject    { klas.new(valid_params) }

  describe 'Object Attributes' do
    it { should respond_to(:event_ref) }
    it { should respond_to(:title)     }
    it { should respond_to(:leaders)   }
  end

  describe 'Object Creation' do
    it { should be_valid }
    it 'saves the object to the database' do
      subject.save
      expect(subject).to be_valid
    end
  end

  describe 'Associations' do
    it { should respond_to(:team)                }
    it { should respond_to(:periods)             }
    it { should respond_to(:participants)        }
  end

  describe 'start and end' do
    it 'handles full-day' do
      subject.start = Time.now
      subject.all_day = true
      subject.valid?
      expect(subject.finish).not_to be_nil
      expect(subject.finish).not_to eq(subject.start)
      expect(subject.finish).to be > subject.start
    end
  end

  describe '#periods' do
    it 'lists periods' do
      expect(subject.periods.length).to eq(0)
    end

    it 'creates periods' do
      subject.save
      subject.periods.create
      expect(subject.periods.length).to eq(1)
    end
  end

  describe '#particpants' do
    it 'lists participants' do
      expect(subject.participants).to eq([])
    end

    it 'creates and lists participants' do
      subject.save
      period      = subject.periods.create
      participant = period.participants.create
      expect(subject.participants).to_not  be_nil
      expect(subject.participants.length).to eq(1)
    end
  end
end

# == Schema Information
#
# Table name: events
#
#  id                       :integer          not null, primary key
#  event_ref                :string(255)
#  team_id                  :integer
#  typ                      :string(255)
#  title                    :string(255)
#  leaders                  :string(255)
#  description              :text
#  location_name            :string(255)
#  location_address         :string(255)
#  lat                      :decimal(7, 4)
#  lon                      :decimal(7, 4)
#  start                    :datetime
#  finish                   :datetime
#  all_day                  :boolean          default(TRUE)
#  published                :boolean          default(FALSE)
#  xfields                  :hstore           default({})
#  external_id              :string(255)
#  signature                :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  ancestry                 :string(255)
#  event_periods_count      :integer          default(0), not null
#  event_participants_count :integer          default(0), not null
#  tags                     :text             default([]), is an Array
#
