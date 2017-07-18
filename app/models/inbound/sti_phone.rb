class Inbound::StiPhone < Inbound

  # KILLME - placeholder to handle database instances

end

# == Schema Information
#
# Table name: inbounds
#
#  id               :integer          not null, primary key
#  team_id          :integer
#  pgr_dialog_id    :integer
#  type             :string
#  proxy            :string
#  subject          :string
#  fm               :string
#  to               :string           default([]), is an Array
#  headers          :hstore           default({})
#  text             :text
#  destination_type :string
#  destination_id   :integer
#  xfields          :hstore           default({})
#  created_at       :datetime
#  updated_at       :datetime
#
