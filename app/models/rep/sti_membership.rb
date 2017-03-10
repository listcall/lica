class Rep::StiMembership < Rep
  def self.base_templates
    %w(_base)
  end
end

# == Schema Information
#
# Table name: reps
#
#  id               :integer          not null, primary key
#  type             :string
#  team_id          :integer
#  name             :string
#  base_template_id :text
#  fork_template_id :text
#  visibility       :string
#  sort_key         :integer
#  values           :hstore           default("")
#  xfields          :hstore           default("")
#  jfields          :jsonb            default("{}")
#  created_at       :datetime
#  updated_at       :datetime
#
