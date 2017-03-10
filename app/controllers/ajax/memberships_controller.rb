class Ajax::MembershipsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json

  def index
    respond_with Membership.all
  end

  def show
    respond_with Membership.find(params[:id])
  end

  def create
    respond_with Membership.create(params[:member])
  end

  def update
    respond_with Membership.update(params[:id], params[:member])
  end

  def destroy
    respond_with Membership.destroy(params[:id])
  end

end
