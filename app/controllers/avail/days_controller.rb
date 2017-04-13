require "un_avails"

class Avail::DaysController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @members  = current_team.memberships.includes(:user).active.by_sort_score
    @unavails = UnAvails.new(@members, params[:start], params[:finish])
  end

  def show
    @member = current_team.memberships.by_user_name(params[:id]).to_a.first
    @avails = @member.avail_days.next_3_months
  end

  def create
    avail  = Avail::Day.create(ok_params(params[:form]))
    usr_nm = params[:user_name]
    url    = "/avail/days/#{usr_nm}"
    if avail.valid? && avail.save
      redirect_to url
    else
      msg = {:warning => 'could not create busy period - please try again'}
      redirect_to url, msg
    end
  end

  def update
    avail = Avail::Day.find(params[:pk])
    if params[:cal].present?
      avail.update_attributes(cal_params(params[:cal]))
      @member  = current_team.memberships.by_user_name(params[:id]).to_a.first
      @avails  = @member.avail_days.next_3_months
      render partial: 'cal_column', layout: false
    else
      avail.send("#{params[:name]}=", params[:value])
      avail.save
      render plain: 'OK'
    end
  end

  def destroy
    avail = Avail::Day.find(params[:avail_id])
    avail.destroy
    @member  = current_team.memberships.by_user_name(params[:id]).to_a.first
    @avails  = @member.avail_days.next_3_months
    render partial: 'cal_column', layout: false
  end

  private
  def ok_params(params)
    # params.permit(:membership_id, :service_type_id, :comment, :start, :finish)
    params.permit(:membership_id, :comment, :start, :finish)
  end

  def cal_params(params)
    params.permit :start, :finish
  end

end
