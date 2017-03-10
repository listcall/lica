# new_pgr

class Pgr::Post::StiAction < Pgr::Post

  # ----- local methods for message data -----
  #def msg_to        ;  [recipient.user.emails.first.try(:address)]  end
  #def msg_from_name ;  recipient.team.pager.from_name               end
  #def msg_from_email;  recipient.team.pager.from_email              end
  #def msg_subject   ;  "PAGE #{Time.now}"                           end
  #def msg_html      ;  "PAGE #{Time.now}"                           end
  #def msg_headers   ;  {"Message-ID" => post.message_id}            end
  #def msg_alt       ;  {}                                           end
  #def msg_text      ;  post.body                                    end

  def author_action
    'action'
  end

end

# == Schema Information
#
# Table name: pgr_posts
#
#  id              :integer          not null, primary key
#  type            :string
#  pgr_dialog_id   :integer
#  author_id       :integer
#  target_id       :integer
#  short_body      :text
#  long_body       :text
#  action_response :string
#  bounced         :boolean          default("false")
#  ignore_bounce   :boolean          default("false")
#  sent_at         :datetime
#  read_at         :datetime
#  xfields         :hstore           default("")
#  jfields         :jsonb            default("{}")
#  created_at      :datetime
#  updated_at      :datetime
#
