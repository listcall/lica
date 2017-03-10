class AvailSyncSvc

  attr_reader :mem_id, :member, :start_date, :finish_date

  def initialize(mem_id, start_date, finish_date)
    @mem_id = mem_id
    @member = Membership.find(mem_id)
    @start_date  = start_date
    @finish_date = finish_date
  end

  def to_service
    Svc::Participant.where(id: partitioned_busy).update_all(status: "Off")
    Svc::Participant.where(id: partitioned_free).update_all(status: "")
    "OK"
  end

  private

  def participations
    @participations ||= @member.svc_participations.between(range)
  end

  def partitioned
    @partitioned ||= participations.partition { |part| busy_hash[part].present? }
  end

  def partitioned_busy
    @partitioned_busy ||= partitioned.last.map {|part| part.id}
  end

  def partitioned_free
    @partitioned_free ||= partitioned.first.map {|part| part.id}
   end

  def range
    @start_date..@finish_date
  end

  def avail_days
    @avail_days = Avail::Days.new(@member.avail_days.to_a)
  end

  def avails_for
    @avails_for ||= avail_days.between(range)
  end

  def busy_hash
    @busy_hash ||= range.to_a.reduce({}) do |hsh, date|
      hsh[date] = avail_days.busy_on?(date)
      hsh
    end
  end
end
