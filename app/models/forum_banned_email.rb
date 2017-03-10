class ForumBannedEmail < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :team

  # ----- Callbacks -----


  # ----- Validations -----

  # ----- Scopes -----

  # ----- Local Methods-----
end

# == Schema Information
#
# Table name: forum_banned_emails
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#
