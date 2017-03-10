module QualCertsHelper
  def attendance_helper(ctype, member)
    return '' unless ctype.has_attendance?
    rule = ctype.attendance_val
    types = rule.types.split(' ')
    tags  = rule.tags.split(' ')
    base = "#{member.first_name} attended at least <b>#{pluralize(rule.event_count, "event")}</b>"
    base << " matching <b>#{rule.title}</b>"                                      if rule.has_title?
    base << " with <b>#{"type".pluralize(types.length)}: #{types.join(', ')}</b>" if rule.has_types?
    base << " with <b>#{"tag".pluralize(tags.length)}: #{tags.join(', ')}</b>"    if rule.has_tags?
    base << " in the past <b>#{pluralize(rule.month_count, "month")}</b>"
    raw base
  end

  def cert_link_helper(cert)
    if cert.link.blank?
      raw "<span class='bPnk'>missing</span>"
    else
      raw "<a href='#{cert.link}' target='_blank'>#{cert.link}</a>"
    end
  end

  def expire_helper(cert)
    if cert.expires_at.blank?
      raw "<span class='bPnk'>missing</span>"
    else
      cert.expires_at.strftime('%Y-%m-%d')
    end
  end

  def alt_certs(certs)
    certs[1..-1].map do |cert|
      cert.title
    end.join(', ')
  end

  def qual_link(qual, member, label)
    raw " (<a href='/quals/#{qual.id}/certs/#{member.id}'>#{label}</a>)"
  end

  def cert_doc_helper(cert)
    ucert = cert.user_cert
    if ucert.try(:attachment_file_name).blank?
      raw "<span class='bPnk'>missing</span>"
    else
      raw "<a href='#{ucert.attachment.url}' target='_blank'>FILE</a>"
    end
  end
end