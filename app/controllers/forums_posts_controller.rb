class ForumsPostsController < ApplicationController

  before_action :authenticate_reserve!

  def create
    @forum  = Forum.find_by(name: params[:forum_id])
    @topic  = ForumTopic.find(params[:forum_post][:forum_topic_id])
    @post   = ForumPost.create(valid_post_params(params[:forum_post]))
    if @post.valid?
      ForumBroadcastSvc.deliver(@post)
      redirect_to forum_topic_path(@forum, @topic)
    else
      redirect_to forum_topic_path(@forum, @topic), alert: 'There was an error creating the post...'
    end
  end

  private

  def valid_post_params(params)
    params.permit(:body, :team_id, :forum_topic_id, :creator_id)
  end

end
