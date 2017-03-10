class PlanSyncSvc

  attr_reader :plan, :start, :finish

  def initialize(plan, start = Time.now, finish = Time.now + 3.months)
    @plan   = plan
    @start  = start
    @finish = finish
  end

  def to_period
    events.each do |day|
      period = period_for(day)
      add_new_participants_for(period)
      period.reload
      del_old_participants_for(period)
    end
    delete_unmatched_periods
    sync_with_avails
  end

  private

  def events
    @events ||= plan.events_between(start, finish)
  end

  def period_for(day)
    period_opts  = {
      svc_id:        plan.svc.try(:id),
      svc_plan_id:   plan.id,
      svc_plan_date: day
    }
    period = Svc::Period.find_or_create_by(period_opts)
    start_val = Time.parse("#{day} #{plan.start.time_part}")
    finis_val = plan.finish ? Time.parse("#{day} #{plan.finish.time_part}") : nil
    obj = {start: start_val, finish: finis_val, all_day: plan.all_day}
    period.update_attributes(obj)
    period.save ; period.reload
  end

  def add_new_participants_for(period)
    plan.member_ids.each do |mem_id|
      participant_opts = {svc_period_id: period.id, membership_id: mem_id}
      Svc::Participant.find_or_create_by(participant_opts)
    end
  end

  def del_old_participants_for(period)
    period.providers.each do |provider|
      provider.destroy unless plan.member_ids.include? provider.membership_id
    end
  end

  def delete_unmatched_periods
    plan.reload
    all_periods = plan.periods.between(start, finish)
    return if all_periods.count == events.count
    all_periods.each do |period|
      next if events.include? period.svc_plan_date
      next if period.providers.active.length != 0
      period.destroy
    end
  end

  def sync_with_avails
    plan.member_ids.each do |mem_id|
      AvailSyncSvc.new(mem_id, start.to_date, finish.to_date)
    end
  end
end
