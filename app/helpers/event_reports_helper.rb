module EventReportsHelper

  def incident_name
    @report.event.title
  end

  def incident_name_with_period
    if @report.event.typ == 'meeting'
      incident_name
    else
      "#{incident_name} - Period #{@report.period.position}"
    end
  end

  #def adjusted_participants
  #  if @report.event.typ == "meeting"
  #    @report.period.participants.registered
  #  else
  #    @report.period.participants
  #  end
  #end

  #def num_participants(team_name = "all")
  #  return unless [current_team.acronym, "all"].include?(team_name)
  #  adjusted_participants.count
  #end

  #def internal_aar_hours
  #  return "TBD" if adjusted_participants.length == 0
  #  adjusted_participants.map do |par|
  #    "#{par.member.last_name} (#{(par.total_hours)} hours)"
  #  end.join(", ")
  #end

  #def participant_role(participant)
  #  return "-OL" if participant.ol
  #  return "-AHC" if participant.ahc
  #  ""
  #end

  #def participant_list
  #  adjusted_participants.map do |par|
  #    "#{par.member.last_name}#{participant_role(par)}"
  #  end.join(', ')
  #end

  #def total_hours(team_name = "all")
  #  return unless [current_team.acronym, "all"].include?(team_name)
  #  participant_minutes = adjusted_participants.map {|par| par.total_minutes}
  #  return "TBD" if participant_minutes.include?("TBD")
  #  (participant_minutes.sum/60).round
  #end

  #def average_hours(team_name = "all")
  #  return unless [current_team.acronym, "all"].include?(team_name)
  #  np = num_participants(team_name)
  #  return "TBD" if np == 0
  #  th = total_hours
  #  return "TBD" if th == "TBD"
  #  (th / np.to_f).round(1)
  #end

  def event_checkbox(type)
    @report.event.typ == type ? 'X' : ''
  end

  def event_label
    @report.event.typ.capitalize
  end

  def unit_hours(base_label, display_label=base_label)
    dev_log "ASDF > #{base_label} > #{display_label}"
    raw <<-HTML
    <td class='valueCell'>#{valid_teams[base_label.upcase]}:</td>
    <td class='valueCell'>#{ @data.count_for(display_label.upcase) }</td>
    <td class='valueCell'>X</td>
    <td class='valueCell'>#{ @data.avg_hours_for(display_label.upcase) }</td>
    <td class='valueCell'>=</td>
    <td class='valueCell'>#{ @data.hours_for(display_label.upcase) }</td>
    HTML
  end

  def valid_teams
    {
      'AIRSQUAD' => 'AIR SQUAD'      ,
      'BAMRU'    => 'BAMRU'          ,
      'DIVE'     => 'DIVE/CLIFF'     ,
      'EXP810'   => 'EXP.POST 810'   ,
      'EXP830'   => 'EXP.POST 830'   ,
      'MSAR'     => 'MOUNTED SAR'    ,
      'RESERVES' => 'RESERVES'       ,
      'SCU'      => 'SCU/COMMS UNIT' ,
      'SMCSAR'   => 'SMCSAR'         ,
      'SVIP'     => 'SVIP'           ,
      'TECH'     => 'TECH RESCUE'    ,
      'CLIFF'    => 'CLIFF RESCUE'   ,
      'SMESB-LL' => 'LAW LIASON'     ,
      'SMESB-GL' => 'GROUP LIASON'   ,
      'HONGUARD' => 'HONOR GUARD'    ,
      'OESDC'    => 'OES DIST COORD' ,
      'BOMB'     => 'BOMB SQUAD'     ,
      'MOTO'     => 'MOTORCYCLE'     ,
      'SWAT'     => 'SWAT'           ,
      'OTHER'    => 'OTHER'          ,
    }
  end

  def valid_base_names
    valid_teams.keys.map{|name| name.split('-').first}.uniq
  end

  def multi_unit_hours
    labels = [
      ['bamru',                 'cliff']   ,
      ['dive',                  'smesb-ll'],
      ['exp810',                'smesb-gl'],
      ['exp830',                'honguard'],
      ['msar',                  'oesdc']   ,
      ['reserves',              'bomb']    ,
      ['scu',                   'moto']    ,
      ['smcsar',                'swat']    ,
      ['svip',                  'other']
    ]
    output = labels.map do |set|
      grp1 = unit_hours(set.first, strip_for(set.first))
      grp2 = unit_hours(set.last, strip_for(set.last))
      "<tr>#{grp1}#{grp2}</tr>"
    end.join
    raw output
  end

  def op_event?
    %w(O C).include?(@report.event.typ)
  end

  def strip_for(lbl)
    op_event? ? lbl.gsub('-ll','') : lbl.gsub('-gl', '')
  end

  def assignment(participant)
    return '' if participant.role.blank?
    participant.event.team.event_roles[participant.role].name
  end

  def time_in(participant)
    formatted_time(participant.start_at)
  end

  def time_out(participant)
    formatted_time(participant.finish_at)
  end

  def formatted_time(time)
    return 'TBD' unless time
    time.strftime('<nobr>%Y-%m-%d %H:%M</nobr>')
  end

  def event_date(format = '%B %d, %Y')
    event = @report.event
    fdate = event.finish
    start = event.start.strftime(format).upcase
    finish = fdate ? fdate.strftime(" TO #{format}").upcase : ''
    finish = '' if finish == " TO #{start}"
    start + finish
  end

  def date_prepared
    @report.updated_at.strftime('%Y-%m-%d')
  end

  def time_prepared
    @report.updated_at.strftime('%H:%M')
  end

  def participant_row(participant, idx)
    return '' unless valid_base_names.include?(base_acronym(participant))
    <<-HTML
      <tr>
        <td class='valueCell'>#{idx + 1}.</td>
        <td class='valueCell'>#{participant.member.full_name}</td>
        <td class='valueCell'>#{report_acronym(participant)}</td>
        <td class='valueCell'>#{time_in(participant)}</td>
        <td class='valueCell'>#{time_out(participant)}</td>
        <td class='valueCell'>#{assignment(participant)}</td>
      </tr>
    HTML
  end

  def base_acronym(participant)
    participant.event.team.acronym
  end

  def report_acronym(participant)
    base = base_acronym(participant)
    return base unless base == 'SMESB'
    op_event? ? 'SMESB-LL' : 'SMESB-GL'
  end

  def participant_rows
    participant_list = @data.team_participants
    return if participant_list.empty?
    rows = participant_list.each_with_index.map do |participant, idx|
      participant_row(participant, idx)
    end
    output = rows.join
    raw output
  end

end
