class PgrUtil::ChanList

  attr_reader :dialog, :author_id

  def initialize(dialog)
    @dialog = dialog
    @author_id = author_id
  end

  def reply_channels_for_target(target_id)
    binding.pry
    use_list = posts_by_author(target_id).map do |post|
      post.author_channel
    end.reverse
    base_list = @dialog.broadcast.outbound_channels.map(&:to_s)
    (use_list + base_list).uniq
  end

  private

  def posts
    @dialog.posts
  end

  def posts_by_author(author_id)
    posts.where(author_id: author_id)
  end
end