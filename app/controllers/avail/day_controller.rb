class Avail::DayController < ApplicationController

  layout false

  def update
    dev_log "AVAIL DAY UPDATE", params
    member = current_team.memberships.by_user_name(params["user_name"]).to_a.first
    opts   = valid_params(params).merge({member: member})
    AvailDaySvc.new(opts).update
    render plain: 'OK'
  end

  private

  def valid_params(params)
    params.permit(:date, :perform)
  end
end
