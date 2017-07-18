require 'app_ext/pkg'

class Membership::AsQuals < ActiveType::Record[Membership]

  # ----- Instance Methods -----

  def view_quals
    rights_list = Qual.by_v_rights(self.team_id, [self.rights]).to_a
    roles_list  = Qual.by_v_roles(self.team_id, self.roles.join(' ')).to_a
    (rights_list + roles_list).uniq.sort { |x,y| x.position <=> y.position }
  end

  def post_quals
    rights_list = Qual.by_p_rights(self.team_id, [self.rights]).to_a
    roles_list  = Qual.by_p_roles(self.team_id, self.roles.join(' ')).to_a
    (rights_list + roles_list).uniq.sort { |x,y| x.position <=> y.position }
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
#  roles        :text             default([]), is an Array
#  xfields      :hstore           default({})
#  created_at   :datetime
#  updated_at   :datetime
#  rights_score :integer          default(0)
#  rank_score   :integer          default(100)
#  role_score   :integer          default(0)
#
