require 'rails_helper'

describe User::Phone do

  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'using FactoryGirl' do
    it 'creates an object' do
      obj = FG.create :user_phone
      expect(obj).to be_a klas
      expect(obj).to be_valid
      expect(obj.id).to be_present
    end
    it 'builds an object' do
      obj = FG.build :user_phone
      expect(obj).to be_a klas
      expect(obj.id).not_to be_present
    end
    it 'works as a user trait' do
      user = FG.create :user_with_phone
      expect(user).to be_a User
      expect(user.phones).not_to be_blank
      expect(user.phones.count).to eq(2)
      expect(user.phones.first).to be_a klas
      expect(user.phones.first.id).to be_present
    end
  end

  describe 'Object Attributes' do
    it { should respond_to(:id)         }
    it { should respond_to(:user_id)    }
    it { should respond_to(:typ)        }
    it { should respond_to(:number)     }
    it { should respond_to(:address)    }
    it { should respond_to(:pagable)    }
    it { should respond_to(:position)   }
  end

  describe 'Associations' do
    it { should respond_to(:user)       }
  end

  describe 'Object Creation' do
    it 'works with a number attribute' do
      obj = klas.new(:number => '123-123-1234')
      expect(obj).to be_valid
    end
  end

  describe '#address' do
    it 'aliases for number' do
      num = '650-123-1234'
      obj = klas.new(:number => num)
      expect(obj.address).to eq("1#{num.gsub('-','')}")
    end
  end
end

# == Schema Information
#
# Table name: user_phones
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  typ        :string(255)
#  number     :string(255)
#  pagable    :boolean
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  visible    :boolean          default(TRUE)
#
