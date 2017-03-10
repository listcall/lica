class FmComment < Forum

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
# Table name: forums
#
#  id             :integer          not null, primary key
#  type           :string(255)
#  team_id        :integer
#  primary_id     :integer
#  primary_type   :integer
#  name           :string(255)
#  position       :integer
#  topic_sequence :integer
#  xfields        :hstore           default("")
#  tags           :text             default("{}"), is an Array
#  created_at     :datetime
#  updated_at     :datetime
#
