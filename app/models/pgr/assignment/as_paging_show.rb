class Pgr::Assignment::AsPagingShow < ActiveType::Record[Pgr::Assignment]

  change_association :broadcast, class_name: 'Pgr::Broadcast::AsPagingShow'

  class << self
    def for(team)
      opts = {:broadcast => [:action, {:sender => [:user, {:team => :org}]}]}
      team.pgr.assignments.becomes(self).includes(opts).order(:id => :desc)
    end
  end
end

# == Schema Information
#
# Table name: pgr_assignments
#
#  id               :integer          not null, primary key
#  sequential_id    :integer
#  pgr_id           :integer
#  pgr_broadcast_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#
