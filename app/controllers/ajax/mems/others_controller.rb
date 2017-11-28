class Ajax::Mems::OthersController < ApplicationController

  before_action :authenticate_member!

  respond_to :json

  def update
    mem = Membership.find(params[:membership_id])
    # mem.attr_set(params["pk"], params["value"])
    mem.xfields[params['pk']] = params['value']
    mem.save
    render plain: 'OK'
  end
end
