class Admin::SvcRepsController < ApplicationController

  before_action :authenticate_member!

  def index
    @reports          = current_team.reps.service.sorted
    @shared_templates = nil # SvcrepTp.shared_by_owner(current_team)
  end

  def create
    @report = Rep::StiService.new(team_id: current_team.id, name: params[:report][:name])
    if @report.valid? && @report.save
      redirect_to '/admin/svc_reps', notice: "Added #{@report.name}"
    else
      redirect_to '/admin/svc_reps', alert:  'There was a problem...'
    end
  end

  def edit
    @rep = current_team.reps.service.find(params[:id])
  end

  def show
    base_opts  = {team: current_team, member: current_membership}
    query_opts = params.slice(:month, :quarter, :year)
    @report = Rep::StiService.find(params[:id]).with_opts(base_opts, query_opts)
    render plain: @report.template_content, layout: 'report'
  end

  def update
    name, value = [params[:name], params[:value]]
    svcrep      = current_team.reps.service.find(params[:id])
    svcrep.send("#{name}=", value)
    if svcrep.valid? && svcrep.save
      render plain: params['pk'], layout: false
    else
      render plain: validation_message(type), layout: false, status: 422
    end
  end

  def destroy
    reports = current_team.reps.service
    report  = reports.find(params['id'])
    name    = report.name
    report.destroy
    redirect_to '/admin/svc_reps', notice: "Deleted #{name}"
  end

  def sort
    reports = current_team.reps.service
    params['report'].each_with_index do |key, idx|
      reports.find(key).update_attribute(:sort_key, idx + 1)
    end
    render plain: 'OK', layout: false
  end

  private

  def period_params
    params.slice(:month, :quarter, :year, :months, :quarters, :years)
  end

  def valid_params(params)
    params.permit :service_type_id, :name, :alias
  end

  def update_event_typ(old_typ, new_typ)
    @current_team.events.where(typ: old_typ).to_a.each do |event|
      event.update_attributes typ: new_typ
    end
  end

  def validation_message(obj)
    msg1 = ActionController::Base.helpers.pluralize(obj.errors.count, 'error')
    msg2 = ' prevented this from being saved: '
    msg3 = obj.errors.full_messages.map.with_index {|msg, i| "#{i+1}) #{msg}"}.join(', ')
    msg1 + msg2 + msg3
  end
end

