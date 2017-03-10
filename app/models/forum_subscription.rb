class ForumSubscription < ActiveRecord::Base

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :team
  belongs_to :membership
  belongs_to :forum

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----

end

# == Schema Information
#
# Table name: forum_subscriptions
#
#  id                 :integer          not null, primary key
#  team_id            :integer
#  forum_id           :integer
#  membership_id      :integer
#  subscription_state :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#
