module AjaxQualCtypesPresenceHelper
  def title_val_for(rule)
    return '' if (tgt = rule['title']).blank?
    rule['title']
  end

  def type_val_for(rule)
    return '' if (tgt = rule['types']).blank?
    tgt.upcase.gsub(',','')
  end

  def tag_val_for(rule)
    return '' if (tgt = rule['tags']).blank?
    tgt.downcase.gsub(',','')
  end

  def month_count_for(rule)
    months = %w(1 2 3 6 9 12 18 24 36 48 60 120 999)
    tgt = rule['month_count']
    gen_opts(months, tgt)
  end

  def event_count_for(rule)
    count = %w(1 2 3 4 5 10)
    tgt = rule['event_count']
    gen_opts(count, tgt)
  end

  def gen_opts(array, tgt)
    val = array.map do |mo|
      sel = mo == tgt ? "selected='selected'" : ''
      "<option #{sel}>#{mo}</option>"
    end.join
    raw val
  end
end