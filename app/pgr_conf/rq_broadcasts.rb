# USE FOR TESTING!!

class RqBroadcasts

  def paging_mail_opts(from, to)
    {
      broadcast:
        {
          sender_action: 'sent page',
          sender_channel: 'web',
          sender_id: from.id,
          email: 'on',
          short_body: "hello world at #{Time.now}",
          partner_recipients: "#{to.team.id}_#{to.id}",
          member_recipients: []
        }
    }
  end

  def mail_reply_opts(from, team)
    {'inbound' =>
       {
         'from' => from.user.emails.first.address,
         'subject' => 'Re: [PAGER]...',
         'to' => "pager@#{team.fqdn}",
         'text' => "email reply at #{Time.now}",
       },
     'In-Reply-To' => "<pgr-#{dialog_id}-1@#{team.fqdn}>"
    }
  end

  def web_reply_opts(from)
    {
      pgr_post:
        {
          pgr_dialog_id: dialog_id.to_s,
          author_id: from.id.to_s,
          short_body: "web reply at #{Time.now}",
        },
      paging_id: broadcast_id.to_s
    }
  end

  def web_followup_opts(to)
    {"fup" => {
      member_recipients: {to.id.to_s => "on"},
      short_body:        "web followup at #{Time.now}",
      channels:          {"email" => "on", "sms" => "on"}
    }}
  end

  def assignment_sid
    Pgr::Assignment.first.sequential_id
  end

  def dialog_id
    Pgr::Dialog.first.id
  end

  def broadcast_id
    Pgr::Broadcast.first.id
  end

end