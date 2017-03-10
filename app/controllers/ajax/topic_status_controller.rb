class Ajax::TopicStatusController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json

  def update
    TopicStatusSvc.new(params[:membership_id], params[:id], params[:status]).update
    render text: 'OK', layout: false
  end

end
