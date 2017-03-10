require 'rails_helper'

describe Team::RankAssignment do

  let(:klas) { described_class }
  let(:subject) { klas.new     }

  it 'works' do
    expect(subject).to_not be_nil
  end

  it 'sets the start time' do
    subject.save
    subject.reload
    expect(subject.started_at).to_not be_nil
  end
end

# == Schema Information
#
# Table name: team_rank_assignments
#
#  id            :integer          not null, primary key
#  team_rank_id  :integer
#  membership_id :integer
#  started_at    :datetime
#  finished_at   :datetime
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
