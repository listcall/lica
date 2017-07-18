module QualCtypesHelper
  def hdr_lbl(type, qual)
    assig = QualAssignment.find_by(qual_id: qual.id, qual_ctype_id: type.id)
    lbl   = assig.status != 'required' ? type.rname : "<u>#{type.rname}</u>"
    r_ttl = assig.status != 'required' ? '' : '<br/>(requried)'
    title = type.name + r_ttl
    raw "<span class='hdrTT' title='#{title}'>#{lbl}</span>"
  end

  def cert_cell(mem, type, qual)
    mem_certs = type.certs_for(mem)
    return '' if mem_certs.count.zero?
    multi = mem_certs.count > 1 ? ' *' : ''
    title = mem_certs.first.try(:title) || ''
    raw <<-ERB
    <button class='btn btn-xs btn-link xlink' data-mname='#{mem.full_name}' data-tname='#{type.rname}' data-qid='#{qual.id}' data-tid='#{type.id}' data-mid='#{mem.id}'>
      #{title + multi}
    </button>
    ERB
  end

  def red_mem(mem, qual)
    types = qual.required_ctypes.to_a
    sync_attendance_certs(mem, types)
    value = types.all? do |type|
      break false if type.blank?
      certs = type.membership_certs.where(membership_id: mem.id)
      break false if certs.length == 0
      break true  unless type.expirable
      certs.any? {|cert| cert.current?}
    end
    value ? 'na' : 'cRed'
  end

  def return_val(certs)
    return false if certs.length == 0
  end

  def bk_class(mem, type, qual)
    mem_certs = type.certs_for(mem)
    assign    = QualAssignment.find_by(qual_ctype_id: type.id, qual_id: qual.id)
    return 'bPnk'  if assign.required?    && mem_certs.empty?
    return ''      if ! assign.required?  && mem_certs.empty?
    return 'bGrn'  if ! type.has_expires? && ! mem_certs.empty?
    exp_dates = mem_certs.map {|cert| cert.expires_at}
    all_dates = exp_dates.select {|date| date.present? }
    return 'bPnk'  if all_dates.blank?
    return 'bPnk'  if all_dates.all? {|date| date < Time.now }
    return 'bOra'  if all_dates.all? {|date| date < Time.now + 1.month  }
    return 'bYel'  if all_dates.all? {|date| date < Time.now + 3.months }
    return 'bGrn'  if all_dates.any? {|date| date > Time.now }
    ''
  end

  def sync_attendance_certs(mem, types)
    types.each { |type| sync_attendance_cert(mem, type) }
  end

  def sync_attendance_cert(mem, type)
    return unless type.try(:has_attendance?)
    AttendanceSyncSvc.new.update(mem, type)
  end

  def gen_cell(mem, type, qual)
    sync_attendance_cert(mem, type) unless qual.required_ctypes.include?(type)
    raw <<-HTML
    <td class="ac #{bk_class(mem, type, qual)}">
      #{cert_cell(mem, type, qual)}
    </td>
    HTML
  end
end
