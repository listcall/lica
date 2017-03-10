module AdminQualCertsHelper

  def qual_cert_hdr_lbl(type, qual)
    assig = QualAssignment.find_by(qual_id: qual.id, qual_ctype_id: type.id)
    lbl   = assig.status != 'required' ? type.name : "<u>#{type.name}</u>"
    raw lbl
  end

  def qual_ctype_headers
    types = current_team.qual_ctypes
    types.to_a.reduce('') do |acc, obj|
      # req = obj.required? ? " *" : ""
      acc + "<th>#{obj.acronym}</th>"
    end
  end

  def create_cert_button(type)
    classes = 'btn btn-xs btn-primary certCreateBtn'
    raw <<-HTML
    <button #{dis_type(type)} class='#{classes}' data-tkey='#{type.rname}' data-tid='#{type.id}'>
      Create
    </button>
    HTML
  end

  def dis_type(type)
    type.ev_types == ['attendance'] ? "disabled='disabled'" : nil
  end

  def dis_cert(cert)
    cert.ev_type == 'attendance' ? "disabled='disabled'" : nil
  end

  def edit_cert_button(mem_cert)
    cls = 'btn btn-xs btn-info certEditBtn'
    ctype = mem_cert.ctype
    raw <<-HTML
    <button #{dis_cert(mem_cert)} id='memCert_#{mem_cert.id}' data-tkey='#{ctype.name}' class='#{cls}'>
      Edit
    </button>
    HTML
  end

  def evidence_link(mem_cert)
    evidence = mem_cert.ev_type
    missing  = raw("<span class='bPnk'> missing </span>")
    return 'NA' if evidence.blank?
    case evidence
    when 'link'
      return missing if mem_cert.user_cert.try(:link).blank?
      raw "<a target='_blank' href='#{mem_cert.link}'>LINK</a>"
    when 'file'
      return missing if mem_cert.user_cert.try(:attachment_file_name).blank?
      raw "<a target='_blank' href='#{mem_cert.attachment.url}'>FILE</a>"
    when 'attendance'
      raw <<-HTML
      <a href='#' class='atLnk' data-certid='#{mem_cert.id}'>
        ROSTER
      </a>
      HTML
    end
  end

  def comment_link(mem_cert)
    comment = mem_cert.user_cert.try(:comment)
    return '' unless mem_cert.ctype.has_comment?
    return '' if comment.blank?
    raw " <small class='comTT' title='#{comment}'>comment</small> "
  end

  def delete_cert_button(mem_cert, qual)
    usn = mem_cert.id
    qal = qual.id
    url = "/quals/#{qal}/certs/#{usn}"
    cls = 'btn btn-xs btn-danger'
    msg = { confirm: 'Are you sure?'}
    unless dis_cert(mem_cert)
      raw link_to 'Delete', url, method: :delete, data: msg, class: cls
    else
      raw "<button class='#{cls}' disabled='disabled'>Delete</button>"
    end
  end

  def qual_exp_date(mc, type, qual)
    return 'NA' unless type.has_expires?
    klas = single_cert_class(mc, type, qual)
    date = mc.expires_at.try(:strftime, '%Y-%m-%d')
    if date.blank?
      raw "<span class='bPnk'>missing</span>"
    else
      raw "<span class='#{klas}'>#{date}</span>"
    end
  end

  def single_cert_class(mem_cert, type, qual)
    expires = mem_cert.expires_at
    assign    = QualAssignment.find_by(qual_ctype_id: type.id, qual_id: qual.id)
    return 'bPnk'  if assign.required? && expires.blank?
    return '' if expires.blank?
    return 'bPnk' if expires < Time.now
    return 'bOra' if expires < Time.now + 1.month
    return 'bYel' if expires < Time.now + 3.months
    return 'bGrn' if expires > Time.now
    ''
  end

  # def qual_bk_class(mem, type, qual)
  #   mem_certs = MembershipCert.where(qual_ctype_id: type.id, membership_id: mem.id).order(:position)
  #   assign    = QualAssignment.find_by(qual_ctype_id: type.id, qual_id: qual.id)
  #   return "bPnk"  if assign.required? && mem_certs.empty?
  #   exp_dates = mem_certs.map {|cert| cert.user_cert.try(:expires_at)}
  #   return "bPnk"  if assign.required? && exp_dates.all? {|date| date.blank? }
  #   return ""      if exp_dates.empty?
  #   return "bPnk" if exp_dates.all? {|date| date.present? && date < Time.now }
  #   return "bOra" if exp_dates.all? {|date| date.present? && date < Time.now + 1.month  }
  #   return "bYel" if exp_dates.all? {|date| date.present? && date < Time.now + 3.months }
  #   return "bGrn" if exp_dates.any? {|date| date.present? && date > Time.now }
  #   ""
  # end

end