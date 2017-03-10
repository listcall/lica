class Admin::ForumIndexController < ApplicationController

  before_action :authenticate_owner!

  def index
    @title = 'Forum Index'
    @forums = ForumDecorator.decorate_collection(current_team.forums.sorted)
  end

  def destroy
    forum = ForumDecorator.new(Forum.find(params[:id]))
    name = forum.display_title
    forum.destroy
    redirect_to '/admin/forum_index', :notice => "#{name} was deleted."
  end

  def create
    @forum  = Forum.create(valid_params params[:forum])
    set_default_access_permissions
    if @forum.valid?
      redirect_to '/admin/forum_index', notice: "Added #{@forum.name}"
    else
      redirect_to '/admin/forum_index', alert:  'There was an error creating the forum...'
    end
  end

  def update
    name, value = [params[:name], params[:value]]
    forum = Forum.find params['pk'].strip
    forum.send("#{name}=", value)
    forum.save
    render text: 'OK', layout: false
  end

  def sort
    params['forum'].each_with_index do |fid, idx|
      Forum.find(fid).update_attributes(position: idx+1)
    end
    render text: 'OK', layout: false
  end

  private

  def valid_params(params)
    params.permit(:name, :type, :team_id)
  end

  def set_default_access_permissions
    p_rights = @forum.post_rights.set(%w(owner manager active reserve))
    v_rights = @forum.view_rights.set(%w(owner manager active reserve))
    @forum.update_attributes view_rights: v_rights, post_rights: p_rights
  end

end
