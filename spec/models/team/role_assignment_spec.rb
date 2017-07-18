require 'rails_helper'

describe Team::RoleAssignment do

  let(:klas) { described_class }
  let(:subject) { klas.new     }

  it 'works' do
    expect(subject).to_not be_nil
  end
end

# == Schema Information
#
# Table name: team_role_assignments
#
#  id            :integer          not null, primary key
#  team_role_id  :integer
#  membership_id :integer
#  started_at    :datetime
#  finished_at   :datetime
#  xfields       :hstore           default({})
#  jfields       :jsonb
#  created_at    :datetime
#  updated_at    :datetime
#
