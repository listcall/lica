class AttendanceSyncSvc

  attr_reader :mlst

  def initialize
    @mlst = {}
    'OK'
  end

  def sync_team(team_id, member_ids = [])
    team = Team.find(team_id)
    team.quals.each do |qual|
      qual.ctypes.using_attendance.each do |ctype|
        qual.post_members.each do |member|
          next if member_ids.present? && member_ids.include?(member.id)
          update(member, ctype)
        end
      end
    end
  end

  def cleanup_team(team_id)
    team = Team.find(team_id)
    team.qual_ctypes.using_attendance.each do |ctype|
      ctype.membership_certs.mc_expired.all.each {|x| x.destroy}
    end
  end

  def member(member_id)
    mem = Membership.find(member_id)
    sync_team(mem.team_id, [member_id])
  end

  def event_participants(event_id)
    event = Event.find(event_id)
    mem_ids = event.participants.pluck(:membership_ids)
    return if mem_ids.blank?
    sync_team(event.team_id, mem_ids)
  end

  def qual(qual_id)
    qual = Qual.find(qual_id)
    mem_ids = qual.post_members.map {|x| x.id}.sort
    sync_team(qual.team_id, mem_ids)
  end

  # ----- support methods -----

  def update(member, ctype)
    return unless ctype.has_attendance?
    if attendance_compliant(member, ctype)
      ensure_memcert_for(member, ctype)
    else
      remove_memcert_for(member, ctype)
    end
  end

  def ensure_memcert_for(member, ctype)
    opts = {membership_id: member.id, qual_ctype_id: ctype.id, ev_type: 'attendance'}
    mcert = MembershipCert.where(opts).first_or_initialize
    mcert.title = 'Attendance'
    mcert.mc_expires_at = expires_for(member, ctype)
    mcert.save
  end

  def remove_memcert_for(member, ctype)
    opts = {membership_id: member.id, qual_ctype_id: ctype.id, ev_type: 'attendance'}
    MembershipCert.where(opts).all.each {|x| x.destroy }
  end

  def attendance_compliant(member, ctype)
    rule = ctype.attendance_val
    attendance_count_for(member, ctype).to_i >= rule.event_count.to_i
  end

  def attendance_count_for(member, ctype)
    attendance_for(member, ctype).count
  end

  def attendance_for(member, ctype)
    key = [member.id, ctype.id]
    @mlst[key] ||= begin
      rule = ctype.attendance_val
      base = member.participations
      base = base.by_event_title(rule.title)   if rule.has_title?
      base = base.by_event_type(rule.types)    if rule.has_types?
      base = base.by_event_tag(rule.tags)      if rule.has_tags?
      base = base.after_date(rule.start_range) if rule.has_month_range?
      base.ordered
    end
  end

  def limited_attendance_for(member, ctype)
    rule = ctype.attendance_val
    attendance_for(member, ctype).limit(rule.event_count.to_i)
  end

  def expires_for(member, ctype)
    rule = ctype.attendance_val
    limited_attendance_for(member, ctype).last.period.event.start + rule.months.months
  end
end
