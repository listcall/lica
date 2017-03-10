require 'rails_helper'

describe User::OtherInfo do

  let(:klas) { described_class }
  subject { klas.new }

  describe 'Object Attributes' do
    it { should respond_to(:label)        }
    it { should respond_to(:value)        }
  end

  describe 'Associations' do
    it { should respond_to(:user)       }
  end
end

# == Schema Information
#
# Table name: user_other_infos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  label      :string(255)
#  value      :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
