class DriveFilesController < ApplicationController

  before_action :authenticate_reserve!

  def index
  end

  def show
    df = DriveFile.find(params[:id])
    df.increment :download_count
    df.save
    redirect_to request.protocol + request.host_with_port + df.attachment.url
  end

  def new
  end

  def create
    DriveFile.create(drive_params)
    redirect_to '/drives'
  end

  def update
  end

  def destroy
    DriveFile.find(params[:id]).try(:destroy)
    redirect_to '/drives'
  end

  private

  def drive_params
    memdat = {membership_id: current_membership.id}
    params.permit(:attachment, :drive_id).merge(memdat)
  end

end
