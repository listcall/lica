class Membership::AsPaging < ActiveType::Record[Membership]

  def alt_name(sender, current_member)
    current_member.user_name == sender.user_name ? user_name : sender.user_name
  end

  def has_pagable_phone?
    phones.pagable.count != 0
  end

  def has_pagable_email?
    emails.pagable.count != 0
  end

  def phone_icon
    if has_pagable_phone?
      'fa fa-phone-square green'
    else
      'fa fa-phone gray'
    end
  end

  def email_icon
    if has_pagable_email?
      'fa fa-envelope green'
    else
      'fa fa-envelope-o gray'
    end
  end

  def icon_score
    score = 0
    score += 1 if has_pagable_email?
    score += 2 if has_pagable_phone?
    score
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
