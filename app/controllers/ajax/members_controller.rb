class Ajax::MembersController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json

  def index
    @members = Rails.cache.fetch([current_team, 'api_member_rost']) do
      list = current_team.memberships.includes([:user]).active.standard_order
      list.to_a.map do |mem|
        {
          id:          mem.id,
          avatar_path: mem.user.avatar.url(:icon),
          full_name:   mem.user.full_name,
          user_name:   mem.user.user_name,
          rank_label:  mem.rank.try(:upcase),
          rank_score:  mem.rank_score,
          role_label:  mem.ordered_roles.join(', ').try(:upcase),
          role_score:  mem.role_score,
          number:      mem.user.phones.first.try(:number),
          address:     mem.user.emails.first.try(:address)
        }
      end
    end
    respond_with @members
  end

  def update
    name  = params['name']
    value = params['value']
    membr = current_team.memberships.find(params['id'])
    respond_with membr.update_attributes({name => value})
  end
end
