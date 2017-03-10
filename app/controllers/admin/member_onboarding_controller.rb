class Admin::MemberOnboardingController < ApplicationController

  before_action :authenticate_owner!

  def index

  end

  def create
    @form = RecruitForm.new(valid_params(params[:membership]))
    if @form.valid? && @form.save
      redirect_to '/admin/member_registry', :notice => "Member was added. (#{@form.member.full_name} / #{@form.member.rank})"
    else
      render :new
    end

  end

  private

  def valid_params(params)
    params.permit *%i(team_id full_name rank phone_typ phone_num email_typ email_adr)
  end

end
