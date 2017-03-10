require 'rails_helper'

describe Event::Report do

  let(:klas) { described_class        }
  subject    { klas.new               }

  describe 'Object Attributes' do
    it { should respond_to(:event_period_id)     }
    it { should respond_to(:position)            }
  end

  describe 'Associations' do
    it { should respond_to :event                  }
    it { should respond_to :period                 }
  end

  describe 'Instance Methods' do
    it { should respond_to :template        }
  end
end

# == Schema Information
#
# Table name: event_reports
#
#  id              :integer          not null, primary key
#  typ             :string(255)
#  event_period_id :integer
#  title           :string(255)
#  position        :integer
#  data            :hstore           default("")
#  published       :boolean          default("false")
#  created_at      :datetime
#  updated_at      :datetime
#
