require 'rails_helper'

describe QualPartnership do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Creation' do
    specify { expect(subject).to be_valid        }
    specify { expect(subject.save).to be_truthy  }
  end

  describe 'Attributes' do
    %i(team_id partner_id).each do |attr|
      it { should respond_to(attr) }
    end
  end

  describe 'Associations' do
    %i(team partner qual).each do |rel|
      it { should respond_to(rel) }
    end
  end
end

# == Schema Information
#
# Table name: qual_partnerships
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  partner_id :integer
#  qual_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
