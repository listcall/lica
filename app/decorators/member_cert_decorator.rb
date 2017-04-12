class MemberCertDecorator < Draper::Decorator
  delegate_all

  def cert_cells
    types = h.current_team.qual_ctypes
    return ''
    # types.to_a.reduce("") do |acc, obj|
      #certs = membership_certs.where(typ: obj.id)
      # certs = membership_certs.where('typ ilike ?', obj.id)
      # acc + cert_cell(certs, obj)
    # end
  end

  # def cert_cell(certs, type_def)
  #   val   = req_val(certs)
  #   klas  = req_class(certs, type_def)
  #   "<td class='#{klas}'><small>#{val}</small></td>"
  # end

  def req_val(certs)
    return '' if certs.blank?
    aster  = certs.length > 1 ? ' *' : ''
    req_link(certs.first, aster)
  end

  def req_link(cert, aster)
    label = "#{cert.title}#{aster}"
    link  = cert.attachment_file_name.present? ? cert.attachment.url : ''
    return label if link.empty?
    "<a href='#{link}'>#{label}</a>"
  end

  private

  def req_class(membership_certs, type_def)
    return 'danger'  if type_def.required? && membership_certs.empty?
    exp_dates = membership_certs.map {|cert| cert.user_cert.expires_at}
    return 'danger'  if type_def.required? && exp_dates.any? {|date| date.blank? }
    return ''        if exp_dates.empty?
    #return "danger"  if type_def.expirable? && exp_dates.any? {|date| date.blank? }
    return 'danger'  if exp_dates.any? {|date| date.present? && date < Time.now }
    return 'warning' if exp_dates.any? {|date| date.present? && date < Time.now + 1.month  }
    return 'info'    if exp_dates.any? {|date| date.present? && date < Time.now + 3.months }
    return 'success' if exp_dates.all? {|date| date.present? && date > Time.now }
    ''
  end

end
