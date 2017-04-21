require 'app_ext/pkg'

class Pgr::Action::StiNone < Pgr::Action

  # ----- attributes -----

  # ----- class methods -----
  def self.label
    'NONE'
  end

  def self.usage_ctxt
    'No action is required'
  end
end

# == Schema Information
#
# Table name: pgr_actions
#
#  id               :integer          not null, primary key
#  pgr_broadcast_id :integer
#  type             :string
#  xfields          :hstore           default("")
#  created_at       :datetime
#  updated_at       :datetime
#
