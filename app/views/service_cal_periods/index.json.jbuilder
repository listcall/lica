Struct.new('Sched', :plan, :occurrence)

def member_names_for(plan)
  return 'TBD' if plan.members.blank?
  plan.members.map {|mem| mem.user_name}.join(', ')
end

def member_data_for(plan)
  plan.members.map do |mem|
    {
      user_name: mem.user_name,
      full_name: mem.full_name,
      avatar:    mem.avatar
    }
  end

end

def composite_date(occurence, plan)
  "#{occurence} #{plan.strftime('%H:%M')}"
end

def occurrence_list
  list = []
  @plans.each do |plan|
    plan.events_between(@start, @finish).each do |occurrence|
      list << Struct::Sched.new(plan, occurrence)
    end
  end
  list
end

json.array! occurrence_list do |sched|
  json.title  member_names_for(sched.plan)
  json.start  composite_date(sched.occurrence, sched.plan.start)
  json.xstart composite_date(sched.occurrence, sched.plan.start)
  json.end    composite_date(sched.occurrence, sched.plan.finish) if sched.plan.finish
  json.xend   composite_date(sched.occurrence, sched.plan.finish) if sched.plan.finish
  json.allDay sched.plan.all_day
  json.id     sched.plan.id
  json.data   member_data_for(sched.plan)
  json.rule   sched.plan.rule_obj.try(:to_hash) || {rule_type: 'Never'}
end