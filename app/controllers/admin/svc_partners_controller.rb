class Admin::SvcPartnersController < ApplicationController

  before_action :authenticate_owner!

  def index
    @svc_partners = Svc::Partner.where(team_id: current_team.id)
    @pickables    = Rep::TemplatePickable.where(picker_team_id: current_team.id)
  end

  def destroy
    ser_par  = ServicePartner.find(params['id'])
    ser_par.destroy
    redirect_to '/admin/service_partners'
  end

  def sort
    ser_pars = ServicePartner.where(team_id: current_team.id)
    params['service'].each_with_index do |key, idx|
      ser_pars.find(key).update_attribute(:position, idx + 1)
    end
    render plain: 'OK', layout: false
  end

  def update
    name, value = [params[:name], params[:value]]
    service     = current_team.svcs.find(params[:id])
    service.send("#{name}=", value)
    if service.valid? && service.save
      render plain: params['pk'], layout: false
    else
      render plain: validation_message(type), layout: false, status: 422
    end
  end

  private

  def valid_params(params)
    params.permit :team_id, :name, :description
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

