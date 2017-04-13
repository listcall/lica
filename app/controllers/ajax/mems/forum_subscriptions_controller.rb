class Ajax::Mems::ForumSubscriptionsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json

  def index
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    phones = user.phones
    respond_with phones
  end

  def create
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    fm_sub = ForumSubscription.create(team_id: current_team.id, membership_id: memid, forum_id: params[:value])
    render plain: 'OK', layout: false
  end

  def update
    field = params['name']
    value = params['value']
    phone = User::Phone.find(params['id'])
    respond_with phone.update_attributes({field => value})
  end

  def destroy
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    fm_sub = ForumSubscription.where(membership_id: memid, forum_id: params[:value]).to_a.first
    fm_sub.destroy
    render plain: 'OK', layout: false
  end

  def sort
    params['phone'].each_with_index do |phone_id, idx|
      User::Phone.find(phone_id).update_attributes(position: idx)
    end
    render plain: 'OK', layout: false
  end

end
