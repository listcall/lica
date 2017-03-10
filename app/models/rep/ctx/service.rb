require 'ext/date'
require 'ostruct'
require 'rep/qdate/period'

class Rep::Ctx::Service

  attr_accessor :team  , :member , :alt  , :report
  attr_accessor :month , :quarter, :year , :period

  def initialize(args = {})
    @member  = args.delete :member
    @team    = args.delete :team
    @report  = args.delete :report
    @period  = Rep::Qdate::Period.build(args.slice(:month, :quarter, :year))
    @month   = args.delete :month
    @quarter = args.delete :quarter
    @year    = args.delete :year
    @alt     = args
  end

  def ctx
    ctx = {}
    ctx['team']         = team_data
    ctx['report']       = report_hash
    ctx['members']      = member_hash
    ctx['services']     = service_hash
    ctx['participants'] = participant_hash
    ctx['months']       = month_hash
    ctx['days']         = day_hash
    ctx
  end

  private

  # ----- team -----------------------------------------------------------------

  def team_data
    {
      name:    team.name,
      acronym: team.acronym,
      logo_url: 'TBD'
    }
  end

  # ----- report ---------------------------------------------------------------

  def dstart  ; @dstart  ||= Date.parse(period.start)  ; end
  def dfinish ; @dfinish ||= Date.parse(period.finish) ; end

  def report_hash
    {
      start:  period.start,
      finish: period.finish,
      months: report_months
    }
  end

  def report_months
    dstart  = Date.parse(period.start)
    dfinish = Date.parse(period.finish)
    @report_months ||= (dstart..dfinish).map do |day|
      day.strftime('%Y-%m')
    end.uniq
  end

  # ----- members --------------------------------------------------------------

  def memb_hsh(mem)
    {
      id:   mem.id,
      last_name:  mem.last_name,
      first_name: mem.first_name,
      avatar_url: mem.avatar.url(:icon)
    }
  end

  def members
    @members ||= team.memberships.includes('user').active
  end

  def member_hash
    @member_hash ||= members.reduce({}) do |hsh, mem|
      hsh[mem.id] = memb_hsh(mem)
      hsh
    end
  end

  # ----- participants ---------------------------------------------------------

  def part_hsh(part)
    {
      id:            part.id,
      membership_id: part.membership_id,
      service_id:    part.service.id,
      start:         part.period.start.strftime('%Y-%m-%d %H:%M'),
      finish:        part.period.finish.strftime('%Y-%m-%d %H:%M'),
      minutes:       ((part.period.finish - part.period.start)/60).round
    }
  end

  def participant_data
    participant_hash.values
  end

  def participant_hash
    @participant_hash ||= participants.reduce({}) do |hsh, prt|
      hsh[prt.id] = part_hsh(prt)
      hsh
    end
  end

  def participants
    @participants ||= report.participants_between(report_start, report_finish)
  end


  # ----- report ---------------------------------------------------------------

  def report_start  ; period.start  ; end
  def report_finish ; period.finish ; end

  def dstart  ; @dstart  ||= Date.parse(report_start)  ; end
  def dfinish ; @dfinish ||= Date.parse(report_finish) ; end

  def report_hash
    {
      id:     report.id,
      start:  period.start,
      finish: period.finish,
      months: report_months
    }
  end

  def report_months
    dstart  = Date.parse(report_start)
    dfinish = Date.parse(report_finish)
    @report_months ||= (dstart..dfinish).map do |day|
      day.strftime('%Y-%m')
    end.uniq
  end

  # ----- services -------------------------------------------------------------

  def svc_hsh(svc)
    svc_id = svc.id
    cnt_sum, min_sum = participant_data.reduce([0, 0]) do |acc, participant|
      next(acc) unless participant[:service_id] == svc_id
      [acc.first + 1, acc.last + participant[:minutes]]
    end
    {
      id:                 svc_id,
      name:               svc.name,
      color:              svc.label_color.gsub('#',''),
      participations:     cnt_sum,
      participant_mins:   min_sum,
      participant_hours:  (min_sum / 60.0).round(1)
    }
  end

  def service_hash
    return [] if services.blank?
    @service_hash ||= services.reduce({}) do |hsh, svc|
      hsh[svc.id] = svc_hsh(svc)
      hsh
    end
  end

  def services
    @services ||= Svc.find(report.service_ids)
  end

  # ----- days -----------------------------------------------------------------

  def day_hsh(day)
    {
      day:     day.strftime('%Y-%m-%d'),
      year:    day.year,
      month:   day.month,
      month_s: day.strftime('%b'),  # Jan, Feb, ...
      mday:    day.mday          ,
      mday_s:  day.strftime('%d'),  # 01, 02, ...
      wday:    day.wday          ,  # 0 => Sunday, ...
      wday_s:  day.strftime('%a'),  # Mon, Tue, ...
      cweek:   day.cweek         ,
      participant_ids: start_on(day)
    }
  end

  def day_hash
    (dstart..dfinish).reduce({}) do |acc, day|
      acc[day.strftime('%Y-%m-%d')] = day_hsh(day)
      acc
    end
  end

  def start_on(day)
    day_start = day.beginning_of_day
    day_end   = day.end_of_day
    participants.select do |part|
      start = part.period.start
      day_start < start && start < day_end
    end.map {|x| x.id}
  end

  # ----- months ---------------------------------------------------------------

  def month_hash
    report_months.reduce({}) do |acc, month|
      acc[month] = {
        name: Time.parse("#{month}-01").strftime('%B'),
        name_abr: Time.parse("#{month}-01").strftime('%b'),
        year: month.split('-').first,
        splits: splits_for(month),
        weeks:  'TBD'
      }
      acc
    end
  end

  def splits_for(month)
    month     = Date.month_parse(month)
    dstart    = month.beginning_of_month
    dfinish   = month.end_of_month
    count     = 1
    split_len = 16
    (dstart..dfinish).each_slice(split_len).reduce({}) do |acc, week|
      acc[count] = {
        member_ids: participants_for(week).map {|par| par.membership_id}.uniq,
        participant_ids: participants_for(week).map {|par| par.id},
        days: (0..split_len-1).map do |idx|
          week[idx] ? week[idx].strftime('%Y-%m-%d') : ''
        end
      }
      count += 1
      acc
    end
  end

  def participants_for(week)
    dstart  = week.first.beginning_of_day
    dfinish = week.last.end_of_day
    participants.select do |par|
      par_start = par.period.start
      dstart < par_start && par_start < dfinish
    end
  end
end
