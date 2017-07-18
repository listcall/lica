# TODO: segregate public/private methods

class Pgr::Outbound::StiEmail < Pgr::Outbound

  def deliver
    return if sent?
    Pgr::Send::Email::Base.env_sender(self).deliver
  end

  # ----- methods for message data -----
  def msg_to        ;  [target_address]                               end
  def msg_from_name ;  target.team.pgr.from_name                      end
  def msg_from_email;  origin_address                                 end
  def msg_html      ;  (post.try(:body) || "") + "<p></p>"            end
  def msg_text      ;  post.try(:body)                                end
  def msg_headers   ;  headers                                        end
  def msg_alt       ;  {}                                             end
  def msg_subject
    if first_post_in_dialog?
      subj = "[#{team.try(:acronym)} PAGE] #{Time.now.strftime("%b-%d %H:%M:%S")}"
      update_attributes stored_subject: subj
      subj
    else
      first = self.dialog_peers.email.first
      "re: #{first.stored_subject}"
    end
  end

  def headers
    {
      'Message-ID' => post.message_id,
      'Outbound-ID' => self.id
    }
  end

  def team_fqdn
    team.try(:fqdn_with_port)
  end

  # ----- html headers - called from html template -----

  def action_footer_html
    return '' unless post.dialog.broadcast.action.present?
    post.dialog.broadcast.action.email_html_helper.footer(self)
  end

  def sender_block_html
    number = author.try(:phones).try(:mobile).try(:first).try(:number)
    nmlink = if number
               stripnum = number.strip.gsub('-','')
               "<a href='tel:#{stripnum}'>#{number}</a>"
             else
               "NA"
             end
    email = author.try(:emails).try(:first).try(:address)
    elink = if email
              "<a href='mailto:#{email}'>#{email}</a>"
            else
              "NA"
            end
    <<-EOF
      <hr>
      Sent by <a href="http://#{team_fqdn}/members/#{author.try(:user_name)}">#{author.try(:full_name)}</a><br/>
      Mobile: #{nmlink}<br/>
      eMail: #{elink}<br/>
      <hr>
      <p></p>
    EOF
  end

  def tracking_pixel_html
    didi = post.try(:dialog).try(:id)
    poti = post.try(:target_id)
    "<img src='http://#{team_fqdn}/pixel/#{didi}/for/#{poti}'><p></p>"
  end

  # ----- text headers - called from text template -----

  def action_footer_text
    return '-------------------------' unless post.dialog.broadcast.action.present?
    post.dialog.broadcast.action.email_text_helper.footer(self)
  end

  def sender_block_text
    <<-EOF.gsub('    ','').strip
    Sent by #{author.try(:full_name)} (#{author.try(:user_name)})
    Mobile: #{author.try(:phones).try(:mobile).try(:first).try(:number) || "NA"}
     eMail: #{author.try(:emails).try(:first).try(:address) || "NA"}
    EOF
  end

  private

  def first_post_in_dialog?
    post.dialog.posts.count == 1
  end
end

# == Schema Information
#
# Table name: pgr_outbounds
#
#  id             :integer          not null, primary key
#  type           :string
#  pgr_post_id    :integer
#  target_id      :integer
#  device_id      :integer
#  device_type    :string
#  target_channel :string
#  origin_address :string
#  target_address :string
#  bounced        :boolean          default(FALSE)
#  xfields        :hstore           default({})
#  sent_at        :datetime
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
