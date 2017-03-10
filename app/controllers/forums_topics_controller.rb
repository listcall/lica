class ForumsTopicsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @memId  = current_membership.id
    @forum  = Forum.by_name(params[:forum_id]).to_a.first
    @topics = @forum.topics.order(:updated_at => :desc)
  end

  def show
    @memId = current_membership.id
    @forum = Forum.by_name(params[:forum_id]).to_a.first
    @topic = @forum.topics.where(scoped_id: params[:id]).to_a.first
    @posts = PostDecorator.decorate_collection(@topic.posts.order(:created_at => :asc))
    @post  = ForumPost.new(forum_topic_id: @topic.id, team_id: @topic.team_id)
    opts   = {membership_id: current_membership.id, forum_topic_id: @topic.id}
    bmark  = ForumTopicBookmark.find_or_create_by(opts)
    bmark.update_attributes(read_at: Time.now)
  end

  def new
    @forum = Forum.by_name(params[:forum_id]).to_a.first
    @topic = ForumTopic.new(forum_id: @forum.id)
  end

  def create
    @forum  = Forum.by_name(params[:forum_id]).to_a.first
    initial_post = params['forum_topic'].delete(:initial_post)
    @topic  = ForumTopic.create(valid_topic_params params['forum_topic'])
    if @topic.valid?
      post_opts = {
          body:           initial_post,
          team_id:        @topic.team_id,
          creator_id:     current_membership.id,
          forum_topic_id: @topic.id
      }
      @post = ForumPost.create(post_opts)
      ForumBroadcastSvc.deliver(@post)
      redirect_to forum_topic_path(@forum.name, @topic.scoped_id)
    else
      redirect_to new_forum_topics_path(@forum), alert: 'There was an error creating the forum...'
    end
  end

  def update
  end

  def delete
  end

  private

  def valid_topic_params(params)
    params.permit(:title, :team_id, :type, :forum_id, :creator_id)
  end

  def valid_post_params()
    params.permit(:body, :team_id, :forum_topic_id, :creator_id)
  end

end
