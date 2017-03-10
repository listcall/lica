require 'rails_helper'

describe User::Address do

  let(:klas) { described_class }
  subject { klas.new }

  describe 'Object Attributes' do
    it { should respond_to(:address1)     }
    it { should respond_to(:address2)     }
    it { should respond_to(:city)         }
    it { should respond_to(:state)        }
    it { should respond_to(:zip)          }
    it { should respond_to(:typ)          }
    it { should respond_to(:position)     }
    it { should respond_to(:full_address) }
  end

  describe 'Associations' do
    it { should respond_to(:user)       }
  end

  describe 'Instance Methods' do
    it { should respond_to(:non_standard_typ?) }
  end

  describe 'Validations' do
    context 'basic' do
      it { should validate_presence_of(:zip)  }
    end
  end

  describe 'Object Creation' do
    before(:each) do
      @valid_attributes = {
              :address1 => 'xxx',
              :city     => 'yyy',
              :state    => 'zzz',
              :zip      => '44444'
      }
    end
    it 'works with valid attribute' do
      @obj = klas.create!(@valid_attributes)
      expect(@obj).to be_valid
    end
  end

  describe 'Object Creation using #full_address=' do
    context 'with valid input' do
      before(:each) { @address = "222 Bell Lane\nArcata CA 94234" }
      it 'generates a valid object' do
        @obj = klas.new(:full_address => @address)
        expect(@obj).to be_valid
        expect(@obj.address1).to eq('222 Bell Lane')
        expect(@obj.city).to eq('Arcata')
        expect(@obj.state).to eq('CA')
        expect(@obj.zip).to eq('94234')
      end
    end
  end

  describe 'Object updating using #full_address=' do
    context 'with valid input' do
      before(:each) do
        @address = "222 Bell Lane\nArcata CA 94234"
        @obj = klas.create(:full_address => @address)
      end
      it 'generates a valid object' do
        expect(@obj).to be_valid
      end
      # it 'updates with valid input' do
      #   @address2 = "333 Bell Lane\nArcata CA 44444"
      #   # @obj.update_attributes(:full_address => @address2)
      #   @obj.update(:full_address => @address2)
      #   expect(@obj).to be_valid
      #   expect(@obj.zip).to eq('44444')
      # end
    end
    context 'with invalid input' do
      before(:each) do
        @address = "222 Bell Lane\nArcata CA"
        @obj = klas.create(:full_address => @address)
      end
      # it 'generates an error with missing zip' do
      #   @address2 = "333 Bell Lane\nArcata CA"
      #   # @obj.update_attributes(:full_address => @address2)
      #   @obj.update(:full_address => @address2)
      #   expect(@obj).not_to be_valid
      # end
      it 'generates an error with missing state' do
        @address2 = "333 Bell Lane\nArcata 44444"
        @obj.update_attributes(:full_address => @address2)
        expect(@obj).not_to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: user_addresses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  typ        :string(255)
#  address1   :string(255)      default("")
#  address2   :string(255)      default("")
#  city       :string(255)      default("")
#  state      :string(255)      default("")
#  zip        :string(255)      default("")
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  visible    :boolean          default("true")
#
