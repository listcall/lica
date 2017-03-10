class TpComment < ForumTopic

  # ----- Attributes -----

  # ----- Associations -----

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----

end

# == Schema Information
#
# Table name: forum_topics
#
#  id          :integer          not null, primary key
#  scoped_id   :integer
#  type        :string(255)
#  team_id     :integer
#  forum_id    :integer
#  title       :string(255)
#  creator_id  :integer
#  assignee_id :integer
#  status      :string(255)
#  xfields     :hstore           default("")
#  tags        :text             default("{}"), is an Array
#  created_at  :datetime
#  updated_at  :datetime
#
