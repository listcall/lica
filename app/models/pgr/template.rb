class Pgr::Template < ActiveRecord::Base

  # ----- Associations -----
  belongs_to :team

  # ----- Callbacks -----

  # ----- Local Methods -----

end

# == Schema Information
#
# Table name: pgr_templates
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  position    :integer
#  name        :string
#  description :string
#  xfields     :hstore           default("")
#  created_at  :datetime
#  updated_at  :datetime
#
