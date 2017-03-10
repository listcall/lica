require 'app_ext/pkg'

class Membership::AsHome < ActiveType::Record[Membership]

  # ----- Attributes -----

  xfield_accessor :widget_col1, :widget_col2

  # ----- Instance Methods -----

  def valid_widgets
    %w(hello_world session_data member_stats guest_stats about)
  end

  def widget_col1
    xfields['widget_col1'] || default_widget_col1
  end

  def widget_col2
    xfields['widget_col2'] || default_widget_col2
  end

  private

  def default_widget_col1
    'session_data'
  end

  def default_widget_col2
    'about member_stats'
  end
end

# == Schema Information
#
# Table name: memberships
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  rights       :string(255)
#  user_id      :integer
#  team_id      :integer
#  rank         :string(255)
#  roles        :text             default("{}"), is an Array
#  xfields      :hstore           default("")
#  created_at   :datetime
#  updated_at   :datetime
#  rights_score :integer          default("0")
#  rank_score   :integer          default("100")
#  role_score   :integer          default("0")
#
