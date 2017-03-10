require_relative 'base/auth'
require_relative 'base/notify'
require_relative 'base/can_can'
require_relative 'base/device_query'

class ApplicationController < ActionController::Base
  extend Forwardable

  def_delegator ActiveSupport::Notifications, :instrument

  protect_from_forgery

  before_action :set_time_zone
  before_action :set_team_id
  around_action :scope_current_team

  def set_time_zone
    Time.zone = 'Pacific Time (US & Canada)'
  end

  def scope_current_team
    Team.current_id = current_team.try(:id)
    yield
  ensure
    Team.current_id = nil
  end

end
