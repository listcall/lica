class Admin::SvcIndexController < ApplicationController

  before_action :authenticate_member!

  def index
    @services = current_team.svcs
  end

  def create
    service  = Svc.new(params[:svc].permit(:name, :description, :color))
    service.team_id = current_team.id
    service.sort_key = 0
    if service.valid? && service.save
      redirect_to '/admin/svc_index', notice: "Added #{service.name}"
    else
      redirect_to '/admin/svc_index', alert: 'There was a problem...'
    end
  end

  def update
    name, value, cid = [params[:name], params[:value], params[:id]]
    qual = current_team.svcs.find(cid)
    qual.update_attribute(name.to_sym, value)
    render plain: 'OK', layout: false
  end

  def destroy
    service = Svc.find params['id']
    service.try(:destroy)
    redirect_to '/admin/svc_index'
  end

  def sort
    params['svc'].each_with_index do |val, idx|
      svc = Svc.find(val.squeeze)
      svc.update_attributes(sort_key: idx + 1)
    end
    render plain: 'OK', layout: false
  end
end

