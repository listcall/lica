class Ajax::Mems::TopicSubscriptionsController < ApplicationController

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
    mem_id = params[:membership_id]
    top_id = params[:value]
    args   = {team_id: current_team.id, membership_id: mem_id, forum_topic_id: top_id}
    ForumTopicSubscription.create(args)
    render text: 'OK', layout: false
  end

  def update
    field = params['name']
    value = params['value']
    phone = User::Phone.find(params['id'])
    respond_with phone.update_attributes({field => value})
  end

  def destroy
    memid  = params[:membership_id]
    tp_sub = ForumTopicSubscription.where(membership_id: memid, forum_topic_id: params[:value]).to_a.first
    tp_sub.try(:destroy)
    render text: 'OK', layout: false
  end

  def sort
    params['phone'].each_with_index do |phone_id, idx|
      User::Phone.find(phone_id).update_attributes(position: idx)
    end
    render text: 'OK', layout: false
  end

end
