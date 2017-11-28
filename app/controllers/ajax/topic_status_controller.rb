class Ajax::TopicStatusController < ApplicationController

  before_action :authenticate_member!

  respond_to :json

  def update
    TopicStatusSvc.new(params[:membership_id], params[:id], params[:status]).update
    render plain: 'OK', layout: false
  end

end
