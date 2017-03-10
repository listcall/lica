class ForumsController < ApplicationController

  before_action :authenticate_reserve!
  def index
    @memId = current_membership.id
    @forums = current_team.forums.sorted.all.select { |forum| forum.viewable_by(current_membership)}
  end

  def new
    @forum = Forum.new
  end

  def mark_all
    @memId = current_membership.id
    @forum = Forum.find_by(name: params[:forum_id])
    @forum.topics.each do |top|
      opts  = {membership_id: @memId, topic_id: top.id}
      bmark = ForumTopicBookmark.find_or_create_by(opts)
      bmark.update_attributes(read_at: Time.now)
    end
    redirect_to "/forums/#{@forum.name}"
  end

  def create
    @forum  = Forum.create(valid_params params[:forum])
    if @forum.valid?
      redirect_to '/forums', notice: "Added #{@forum.name}"
    else
      redirect_to '/forums/new', alert: 'There was an error creating the forum...'
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
