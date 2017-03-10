module AvailHelper
  def day_label(offset = 0)
    (Time.now + offset.days).strftime('%b %e')
  end

  def day_helper(member, offset = 0)
    day = Time.now + offset.days
    if @unavails.for(member).busy_on?(day)
      "<td align=center style='background-color: pink;'>No</td>"
    else
      '<td></td>'
    end
  end

  def return_date_helper(member, offset)
    day = Time.now + offset.days
    return_date = @unavails.for(member).return_date(day)
    return_date.nil? ? '' : (return_date + 1.day).strftime('%a %b %d')
  end

  def oot_comment_for(member)
    @unavails.for(member).current_comment
  end

  def unavails_for(member)

  end
end