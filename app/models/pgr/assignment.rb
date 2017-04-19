class Pgr::Assignment < ActiveRecord::Base

  acts_as_sequenced :scope => :pgr_id

  belongs_to :pgr      , class_name: 'Pgr'
  belongs_to :broadcast, class_name: 'Pgr::Broadcast'#, foreign_key: :pgr_broadcast_id

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
