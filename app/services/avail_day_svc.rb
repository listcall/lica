class AvailDaySvc

  attr_reader :date, :member, :action

  def initialize(opts)
    @date   = Date.parse opts["date"]
    @member = opts["member"]
    @action = opts["perform"]
  end

  def update
    sign_in  if action == "signIn"
    sign_out if action == "signOut"
  end

  private

  def sign_in
    return unless member.avail_days.busy_on?(date)
    periods = member.avail_days.periods_on(date)
    periods.each do |period|
      (dev_log "single_day"; period.destroy    ; next) if period.at_single_day(date)
      (dev_log "at_start"  ; period.start_bump ; next) if period.at_start(date)
      (dev_log "at_finish" ; period.finish_bump; next) if period.at_finish(date)
      dev_log "split_on"; period.split_on(date)
    end
  end

  def sign_out
    return if member.avail_days.busy_on?(date)
    Avail::Day.create(membership: member, start: date, finish: date)
  end
end
