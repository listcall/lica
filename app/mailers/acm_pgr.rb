class AcmPgr < BaseMailer
  def for(outbound)
    @outbound = outbound
    mail(opts_from(outbound))
    mail.header['Outbound-ID'] = outbound.id
    mail
  end

  private

  def opts_from(outbound = nil)
    return {} if outbound.blank?
    return {} if outbound.target_address.blank?
    {
      to:          outbound.target_address,
      from:        "pager@#{outbound.team_domain}",
      subject:     outbound.msg_subject,
      message_id:  outbound.post_id,
    }
  end
end
