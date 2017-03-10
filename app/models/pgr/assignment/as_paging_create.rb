class Pgr::Assignment::AsPagingCreate < ActiveType::Record[Pgr::Assignment]

  change_association :broadcast, class_name: 'Pgr::Broadcast::AsPagingCreate'

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
