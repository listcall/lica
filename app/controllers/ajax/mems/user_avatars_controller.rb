require 'mini_magick'
require 'fileutils'

class Ajax::Mems::UserAvatarsController < ApplicationController

  before_action :authenticate_member!

  def index
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    phones = user.phones
    respond_with phones
  end

  def create
    base_dir = '/tmp/avatars'
    FileUtils::mkdir_p base_dir
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    tmpfil = "#{user.user_name}_#{Time.now.strftime("%y%m%d_%H%M%S")}"
    tmpext = params['avatarPhoto'].original_filename.split('.').last
    imgfil = "#{base_dir}/#{tmpfil}.#{tmpext}"
    FileUtils::cp(params['avatarPhoto'].tempfile.path, imgfil)
    args   = "#{params['photoWidth']}x#{params['photoHeight']}+#{params['photoLeft']}+#{params['photoTop']}"
    photo  = MiniMagick::Image.open(imgfil)
    photo.crop(args)
    photo.write(imgfil)
    user.update_attributes(avatar: File.open(imgfil))
    dev_log 'IMAGE CROP', args
    redirect_to "/members/#{user.user_name}"
  end

  def update
    dev_log 'UPDATE'
    field  = params['name']
    value  = params['value']
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    respond_with user.update_attributes({field => value})
  end

end
