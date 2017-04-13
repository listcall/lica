class ActionReportBot

  attr_reader :period, :event, :team

  def initialize(opts)
    @period = opts[:period]
    @event  = period.event
    @team   = event.team
    @team_count = {}
    @team_mins  = {}
    @part_mins  = {}
    @hours_format = opts.fetch(:hours_format, :integer)
  end

  def team_acronyms
    @team_acronyms ||= team_hash.keys.sort
  end

  def team_hash
    @team_hash ||= period.descendants.reduce({team.acronym => period}) do |acc, period|
      key = period.team.acronym
      acc.merge({key => period}) do |key, left, right|
        Array(left) + Array(right)
      end
    end
  end

  def team_participants
    @team_hash.values.map {|x| Array(x)}.flatten.map {|period| period.participants.order_by_name}.flatten
  end

  def multi_count_for(*acronyms)
    targets = acronyms.map {|str| str.upcase}
    counts  = targets.map {|tgt| count_for(tgt)}
    counts.select {|x| x.is_a?(Fixnum)}.sum
  end

  def multi_mins_for(*acronyms)
    targets     = acronyms.map {|str| str.upcase}
    target_mins = targets.map {|tgt| mins_for(tgt)}
    return 'TBD' if target_mins.include? 'TBD'
    target_mins.select {|x| x.is_a?(Fixnum)}.sum
  end

  def multi_hours_for(*acronyms)
    val = multi_mins_for(*acronyms)
    return val if val.is_a?(String)
    mins_to_hours(val)
  end

  def multi_avg_mins_for(*acronyms)
    return 'TBD' if multi_mins_for(*acronyms) == 'TBD'
    return 'NA'  if multi_count_for(*acronyms) == 0
    multi_mins_for(*acronyms)/multi_count_for(*acronyms)
  end

  def count_for(team)
    return '' unless team_hash[team]
    @team_count[team] ||= Array(team_hash[team]).reduce(0) do |acc, period|
      acc + period.participants.count
    end
  end

  def mins_for(team)
    return '' unless team_hash[team]
    @team_mins[team] ||= calc_mins_for(team)
  end

  def avg_mins_for(team)
    return '' unless team_hash[team]
    return 'NA' if count_for(team) == 0
    return mins_for(team) if mins_for(team).is_a?(String)
    mins_for(team) / count_for(team)
  end

  def hours_for(team)
    val = mins_for(team)
    return val if val.is_a?(String)
    mins_to_hours(val)
  end

  def avg_hours_for(team)
    val = avg_mins_for(team)
    return val if val.is_a? String
    mins_to_hours(val)
  end

  private

  def mins_to_hours(mins)
    case @hours_format
      when :decimal then (mins / 60.to_f).round(1)
      when :integer then mins / 60
      else mins / 60
    end
  end

  def calc_mins_for(team)
    period_list = Array(team_hash[team])
    participant_list = period_list.map {|period| period.participants}.flatten
    participant_mins = participant_list.map {|part| part_mins_for(part)}
    return 'TBD' if participant_mins.include? 'TBD'
    participant_mins.sum
  end

  def part_mins_for(participant)
    @part_mins[participant.id] ||= participant.total_minutes
  end

end