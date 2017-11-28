class EventReportsController < ApplicationController

  before_action :authenticate_member!

  def index
    #@reports = EventReport.all
  end

  def show
    @report = report_by_period_ref(params[:id])
    @data   = ActionReportBot.new(:period => period_by_period_ref(params[:id]), :hours_format => :decimal)
    # noinspection RubyArgCount
    render @report.template, {:layout => nil}
  end

  def edit
    @report = report_by_period_ref(params[:id])
    @period_ref   = params[:id]
  end

  def update
    @report = Event::Report.find(params[:id])
    @period_ref   = @report.period.period_ref
    @report.update_attributes(valid_params(params[:event_report]))
    if @report.valid? && @report.save
      redirect_to "/event_reports/#{@period_ref}"
    else
      render :edit
    end
  end

  private

  KEYS = %i(unit_leader signed_by description)

  def valid_params(params)
    params.permit(*KEYS)
  end

  def report_by_period_ref(id)
    event_ref, position = id.split('_')
    event  = current_team.events.find_by_event_ref(event_ref)
    period = event.periods.find_by_position(position)
    find_or_create_smso_aar(period)
  end

  def period_by_period_ref(id)
    event_ref, position = id.split('_')
    event  = current_team.events.find_by_event_ref(event_ref)
    event.periods.find_by_position(position)
  end

  def find_or_create_smso_aar(period)
    if period.reports.smso_aars.all.empty?
      opts = {typ: 'smso_aar', title: period.event.title}
      opts[:description] = period.event.description
      opts[:event_period_id] = period.id
      Event::Report.create(opts)
    else
      period.reports.smso_aars.to_a.first
    end
  end

  #def create_internal_aar
  #  return if self.event.typ == "meeting"
  #  if self.event_reports.internal_aars.all.empty?
  #    title = "Internal AAR - Period #{self.position}"
  #    opts = {typ: "internal_aar", event_id: self.event.id, title: title}
  #    opts[:unit_leader] = Role.member_for("UL").try(:full_name)  || "TBD"
  #    opts[:signed_by]   = Role.member_for("SEC").try(:full_name) || "TBD"
  #    opts[:description] = "TBD"
  #    self.event_reports << EventReport.create(opts)
  #  end
  #end

end
