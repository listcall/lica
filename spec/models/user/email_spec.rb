require 'rails_helper'

describe User::Email do

  let(:klas) { described_class }
  subject { klas.new           }

  describe 'using FactoryGirl' do
    it 'creates an object' do
      obj = FG.create :user_email
      expect(obj).to be_a klas
      expect(obj).to be_valid
      expect(obj.id).to be_present
    end
    it 'builds an object' do
      obj = FG.build :user_email
      expect(obj).to be_a klas
      expect(obj.id).not_to be_present
    end
    it 'works as a user trait' do
      user = FG.create :user_with_email
      expect(user).to be_a User
      expect(user.emails).not_to be_blank
      expect(user.emails.count).to eq(2)
      expect(user.emails.first).to be_a klas
      expect(user.emails.first.id).to be_present
    end
  end

  describe 'Object Attributes' do
    before(:each) { @obj = klas.new }
  end

  describe 'Associations' do
    before(:each) { @obj = klas.new }
    specify { expect(@obj).to respond_to(:user)       }
  end

  describe 'Instance Methods' do
    before(:each) { @obj = klas.new }
    specify { expect(@obj).to respond_to(:non_standard_typ?) }
  end

  describe 'Validations' do
    context 'basic' do
      it { should validate_presence_of(:address)     }
    end
  end
end

# == Schema Information
#
# Table name: user_emails
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  typ        :string(255)
#  address    :string(255)
#  pagable    :boolean
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  visible    :boolean          default("true")
#
