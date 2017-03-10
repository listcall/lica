class ForumOutboundEmail < ForumOutbound

  # ----- local methods for message data -----
  def msg_to        ;  [recipient.user.emails.first.try(:address)]  end
  #def msg_from_name ;  post.forum.name                              end
  def msg_from_name ;  post.creator.user_name                       end
  def msg_from_email;  post.forum.email_address                     end
  def msg_html      ;  ''                                           end
  def msg_headers   ;  {'Message-ID' => post.message_id}            end
  def msg_alt       ;  {}          end
  def msg_text      ;  post.body   end
  def msg_subject
    base = "[#{post.team.try(:acronym)} #{post.forum.name.capitalize}] #{topic.title}"
    if topic.posts.count == 1
      base
    else
      "re: #{base}"
    end
  end

end

# == Schema Information
#
# Table name: forum_outbounds
#
#  id            :integer          not null, primary key
#  forum_post_id :integer
#  recipient_id  :integer
#  type          :string(255)
#  bounced       :boolean          default("false")
#  xfields       :hstore           default("")
#  read_at       :datetime
#  sent_at       :datetime
#  created_at    :datetime
#  updated_at    :datetime
#
