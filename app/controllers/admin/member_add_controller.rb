class Admin::MemberAddController < ApplicationController

  before_action :authenticate_manager!

  def new
    @form = RecruitForm.new(team_id: current_team.id)
  end

  def create
    @form = RecruitForm.new(valid_params(params[:membership]))
    if @form.valid? && @form.save
      redirect_to '/admin/member_add', :notice => "Member was added. (#{@form.member.full_name} / #{@form.member.rank})"
    else
      render :new
    end

  end

  private

  def valid_params(params)
    params.permit *%i(team_id title first_name middle_name last_name rank form_rank phone_typ phone_num email_typ email_adr)
  end

end
