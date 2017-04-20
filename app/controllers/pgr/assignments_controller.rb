# integration_test: requests/pgr/multi_partner

require 'ext/ar_proxy'

class Pgr::AssignmentsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @assignments = load_assignments
  end

  def new
    build_broadcast
    @list_type    = cookie_list_type
    @partners     = PageBot.new(current_team)
    @memberships  = membership_scope
    @events       = current_team.events
  end

  def create
    build_broadcast
    save_broadcast or render('new')
  end

  private

  # ----- assignments -----

  def load_assignments
    @assignments_container ||= VwAssignments.new(current_team).assignments
  end

  # ----- broadcasts -----

  def build_broadcast
    @broadcast ||= broadcast_scope.build
    @broadcast.attributes = broadcast_params
  end

  def save_broadcast
    if @broadcast.save
      # TODO - run this in background !!!!!
      Pgr::Util::GenBroadcast.new(@broadcast).generate_all.deliver_all
      redirect_to paging_path
    end
  end

  def broadcast_params
    broadcast_params = generate_broadcast_params(params[:broadcast])
    broadcast_params ? broadcast_params.permit(permitted_broadcast_params) : {}
  end

  def broadcast_scope
    Pgr::Broadcast::AsPagingCreate.where(team: current_team)
  end

  # ----- broadcast utility methods -----

  def permitted_broadcast_params
    [
      {:assignments_attributes => [:pgr_id]},
      {:action_attributes      => [:type, :period_id, :position, :role]},
      {:recipient_ids => []},
      :sender_id,
      :sender_channel,
      :email,
      :sms,
      :short_body,
      :long_body
    ]
  end

  def generate_broadcast_params(params)
    return nil if params.blank?
    params[:assignments_attributes] = assignment_params(params)
    params[:recipient_ids]          = recipient_ids(params)
    params
  end

  # ----- assignment and recipient list -----

  def assignment_params(params)
    dev_log params.to_s
    team_ids = params[:partner_recipients].split(',').map do |x|
      x.split('_').first
    end.uniq
    pagers = [current_team.pgr] + team_ids.map {|x| Team.find(x).pgr }.uniq
    pagers.map {|pgr| {pgr_id: pgr.id}}
  end

  def member_ids(params)
    recips = params.to_unsafe_h[:member_recipients] || {}
    recips.to_a.reduce([]) do |acc, val|
      acc << val.first if val.last == '1'; acc
    end
  end

  def partner_member_ids(params)
    params[:partner_recipients].split(',').map {|x| x.split('_').last}.select {|y| y.to_i != 0}
  end

  def partner_role_ids(params)
    params[:partner_recipients].split(',').map do |x|
      team, role = x.split('_')
      next if role.to_i != 0
      Team.find_by(id: team).memberships.in_role(role).pluck(:id)
    end.flatten.select {|x| x.present?}
  end

  def recipient_ids(pms)
    ids = member_ids(pms) + partner_member_ids(pms) + partner_role_ids(pms)
    ids.map {|x| x.to_i}.uniq
  end

  # ----- membership list -----

  def cookie_list_type
    cookies['paging_reserves'] == 'true' ? 'reserves' : 'active'
  end

  def membership_scope
    select = Membership::AsPaging.where(team: current_team)
    scoped = cookie_list_type == 'active' ? select.active : select.reserve
    scoped.includes([:user, :team]).by_sort_score
  end
end
