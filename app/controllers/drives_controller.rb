class DrivesController < ApplicationController

  before_action :authenticate_reserve!
  def index
    @memId  = current_membership.id
    @drives = current_team.drives.all.select { |drive| drive.viewable_by(current_membership)}
  end

  def new
    @drive = Forum.new
  end

  def mark_all
    @memId = current_membership.id
    @drive = Forum.find_by(name: params[:drive_id])
    @drive.topics.each do |top|
      opts  = {membership_id: @memId, topic_id: top.id}
      bmark = ForumTopicBookmark.find_or_create_by(opts)
      bmark.update_attributes(read_at: Time.now)
    end
    redirect_to "/drives/#{@drive.name}"
  end

  def create
    @drive  = Forum.create(valid_params params[:forum])
    if @drive.valid?
      redirect_to '/drives', notice: "Added #{@drive.name}"
    else
      redirect_to '/drives/new', alert: 'There was an error creating the drive...'
    end
  end

  def update
  end

  def delete
  end

  private

  def valid_params(params)
    params.permit(:name, :type, :team_id)
  end

end
