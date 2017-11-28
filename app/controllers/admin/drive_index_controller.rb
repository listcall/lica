class Admin::DriveIndexController < ApplicationController

  before_action :authenticate_member!

  def index
    @title = 'Drive Index'
    @drives = DriveDecorator.decorate_collection(current_team.drives)
  end

  def destroy
    drive = DriveDecorator.new(Drive.find(params[:id]))
    name = drive.display_title
    drive.destroy
    redirect_to '/admin/drive_index', :notice => "#{name} was deleted."
  end

  def create
    @drive  = Drive.create(valid_params params[:forum])
    set_default_access_permissions
    if @drive.valid?
      redirect_to '/admin/drive_index', notice: "Added #{@drive.name}"
    else
      redirect_to '/admin/drive_index', alert:  'There was an error creating the drive...'
    end
  end

  def update
    name, value = [params[:name], params[:value]]
    drive = Drive.find params['pk'].strip
    drive.send("#{name}=", value)
    drive.save
    render plain: 'OK', layout: false
  end

  def sort
    params['drive'].each_with_index do |fid, idx|
      Drive.find(fid).update_attributes(position: idx+1)
    end
    render plain: 'OK', layout: false
  end

  private

  def valid_params(params)
    params.permit(:name, :type, :team_id)
  end

  def set_default_access_permissions
    v_rights = @drive.view_rights.set(%w(owner manager active reserve))
    p_rights = @drive.post_rights.set(%w(owner manager active reserve))
    @drive.update_attributes view_rights: v_rights, post_rights: p_rights
  end

end
