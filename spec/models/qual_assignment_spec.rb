require 'rails_helper'

describe QualAssignment do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Creation' do
    specify { expect(subject).to be_valid        }
    specify { expect(subject.save).to be_truthy  }
  end

  describe 'Attributes' do
    list = %i(qual_id qual_ctype_id)
    list.each { |att| it { should respond_to(att) } }
  end

  describe 'Associations' do
    list = %i(qual qual_ctype)
    list.each { |rel| it { should respond_to(rel) } }
  end
end

# == Schema Information
#
# Table name: qual_assignments
#
#  id            :integer          not null, primary key
#  qual_id       :integer
#  qual_ctype_id :integer
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
