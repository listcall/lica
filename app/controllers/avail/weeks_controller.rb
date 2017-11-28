class Avail::WeeksController < ApplicationController

  # include ServiceCtrlUtil
  before_action :authenticate_member!

  # all team members - availability view
  def index
    # @quarter  = {
    #   :team_id => current_team.id,
    #   :year    => params["year"].try(:to_i)    || Time.now.current_year,
    #   :quarter => params["quarter"].try(:to_i) || Time.now.current_quarter
    # }
    # @sched_set = (1..13).map do |num|
    #   quarter = @quarter.clone
    #   quarter[:week]       = num
    #   Avail::Week.find_or_create_by(quarter)
    # end
    @members = current_team.memberships.standard_order
  end

  # the individual availability view
  def show
    @member   = current_team.memberships.by_user_name(params[:id]).to_a.first
    @quarter  = {
      :team_id => current_team.id,
      :year    => params['year'].try(:to_i)    || Time.now.year,
      :quarter => params['quarter'].try(:to_i) || Time.now.current_quarter,
      :membership_id => @member.id,
    }
    @avail_set = (1..13).map do |num|
      new_quarter = @quarter.merge({week: num})
      Avail::Week.find_or_create_by(new_quarter)
    end
  end

  def update
    avail = Avail::Week.find(params[:pk])
    avail.send("#{params[:name]}=", params[:value])
    avail.save
    render plain: 'OK'
  end
end
