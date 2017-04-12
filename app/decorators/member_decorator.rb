class MemberDecorator < Draper::Decorator
  delegate_all

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