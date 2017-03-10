class AvailsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @members  = current_team.memberships.active
  end

  def show
    @member = current_team.memberships.find_by(user_name: params[:id])
    @avails = @member.avail_days.order(:start)
  end

  def create
    avail = ServiceAvail.create(ok_params(params[:form]))
    svc_id = params[:form][:service_type_id]
    usr_nm = params[:user_name]
    url    = "/avails/#{usr_nm}"
    if avail.valid? && avail.save
      redirect_to url
    else
      msg = {:warning => 'could not create busy period - please try again'}
      redirect_to url, msg
    end
  end

  def update
    avail = ServiceAvail.find(params[:pk])
    if params[:cal].present?
      @member  = current_team.memberships.find_by(user_name: params[:id])
      @service = Service.find(params[:service_id])
      avail.update_attributes(cal_params(params[:cal]))
      render partial: 'cal_column', layout: false
    else
      avail.send("#{params[:name]}=", params[:value])
      avail.save
      render text: 'OK'
    end
  end

  def destroy
    @member  = current_team.memberships.find_by(user_name: params[:id])
    @service = Service.find(params[:service_id])
    avail = ServiceAvail.find(params[:avail_id])
    avail.destroy
    render partial: 'cal_column', layout: false
  end

  private

  def ok_params(params)
    params.permit :membership_id, :service_type_id, :comment, :start, :finish
  end

  def cal_params(params)
    params.permit :start, :finish
  end


end
