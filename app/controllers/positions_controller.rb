class PositionsController < ApplicationController

  before_action :authenticate_member!

  def index
    @positions = current_team.positions  #.includes([:team, :qual_ctypes])
    @pos_parts = current_team.position_partners
  end

  def show
    @role      = current_team.roles.find_by_acronym(params[:id])
    @positions = current_team.positions
    @position  = @role.position
    @quarter   = {
      :position_id => @position.id,
      :year        => params['year'].try(:to_i)    || Time.now.current_year,
      :quarter     => params['quarter'].try(:to_i) || Time.now.current_quarter
    }
    @tab       = params[:tab] || 'rost'
    @sched_set = (1..13).map do |num|
      quarter = @quarter.clone
      quarter[:week]        = num
      Position::Period.find_or_create_by(quarter)
    end
    @members = current_team.memberships.where(id: @sched_set.first.avail_member_ids)
  end

  # def update
  #   avail = Avail::Week.find(params[:pk])
  #   avail.send("#{params[:name]}=", params[:value])
  #   avail.save
  #   render plain: 'OK'
  # end

  # all team members (assignment and plan tab)
  # def show
  #   # @position = current_team.positions.find_by(:role_acronym => params[:id])
  # end

  # def update
  #   id    = params[:id]N
  #   name  = params[:name]
  #   value = params[:value]
  #   member = current_team.memberships.find(id)
  #   member.update_attribute(name.to_sym, value || [])
  #   render plain: 'OK'
  # end
end
