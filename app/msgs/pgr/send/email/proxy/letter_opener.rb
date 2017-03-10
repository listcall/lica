# this should use standard rails mailer
# it is intercepted by the 'opener'
# delivery method and opens the email
# in a web browser

class Pgr::Send::Email::Proxy::LetterOpener

  attr_reader :outbound

  def initialize(outbound = nil)
    @outbound = outbound
    @opts     = opts_from(outbound) || default_opts
  end

  def opts_from(outbound = nil)
    return nil if outbound.nil?
    {
      to:         outbound.msg_to.join(', '),
      from:       "pager@#{outbound.dialog.broadcast.team.fqdn}",
      subject:    outbound.msg_subject,
      message_id: outbound.post.message_id,
      body:       outbound.msg_text,
    }
  end

  def default_opts
    {
      to:         'qwer@x.com',
      from:       'asdf@y.com',
      subject:    'qwer',
      body:       'test',
      message_id: '<22@zz.com>'
    }
  end

  def deliver
    AcmPgr.for(@opts).deliver
  end
end