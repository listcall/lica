require File.dirname(__FILE__) + '/report_helpers'

class ReportSummarySvc

  include ReportHelpers

  attr_accessor :team, :start, :finish

  def initialize(team, start = '', finish = '', type = '')
    @team   = team
    @start  = start.blank? ? Time.parse(start_of_year) : Time.parse(start)
    @finish = finish.blank? ? Time.now : Time.parse(finish)
    @type   = type
    @ev_hrs = {}
  end

  def training_header
    @thd ||= "#{training_list.count} Trainings (#{training_hours.prc} hours)"
  end

  def operation_header
    @ohd ||= "#{operation_list.count} Operations (#{operation_hours.prc} hours)"
  end

  def meeting_header
    @mhd ||= "#{meeting_list.count} Meetings (#{meeting_hours.prc} hours)"
  end

  def community_header
    @chd ||= "#{community_list.count} Community Events (#{community_hours.prc} hours)"
  end

  def summary_html
    <<-EOF
      #{training_header},
      #{operation_header},
      #{meeting_header},
      #{community_header}
    EOF

  end

  def event_detail(event_list)
    sorted_list = if @type == 'hours'
                    event_list.sort_by {|x| [-1 * event_hours(x), x.start]}
                  else
                    event_list
                  end
    list = sorted_list.map do |ev|
      <<-EOF
      <tr>
        <td style='border: 0px solid white;'>#{event_hours(ev)} hours</td>
        <td style='border: 0px solid white;'>#{ev.start.strftime("%b %d")}</td>
        <td style='border: 0px solid white;'>
          <a href='/events/#{ev.event_ref}' target='_blank'>#{ev.title}</a>
        </td>
      </tr>
      EOF
    end.join
    "<table class='xTable' style='font-size: 10px;'>#{list}</table>"
  end

  def summary_totals
    num_hours  = training_hours + operation_hours + meeting_hours + community_hours
    "#{num_events} Events (#{num_hours.prc} hours)"
  end

  private

  def start_of_year
    Time.now.strftime('%Y-01-01')
  end

end