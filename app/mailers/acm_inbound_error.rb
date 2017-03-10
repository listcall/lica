# new_pager

class AcmInboundError < BaseMailer

  def destination_email_invalid(inbound)
    # TODO: add partials for different error types
    # TODO: add helper to calculate levenshen distance for mis-spellings
    @inbound = inbound
    @errors  = inbound.errors
    mail std_opts(inbound, 'Error: Invalid Email Address')
  end

  def origin_email_nonmember(inbound)
    @inbound = inbound
    mail std_opts(inbound, 'Error: No Email Access')
  end

  def origin_email_unrecognized(inbound)
    @inbound = inbound
    mail std_opts(inbound, 'Error: Unrecognized Address')
  end

  def origin_phone_nonmember(inbound)
    @inbound = inbound
    mail std_opts(inbound, 'Error: No SMS Access')
  end

  def origin_phone_unrecognized(inbound)
    @inbound = inbound
    mail std_opts(inbound, 'Error: Phone Number Unrecognized')
  end

  private

  def std_opts(inbound, subject)
    {
      to:      inbound.fm,
      from:    "pager_error@#{inbound.team_domain}",
      subject: subject
    }
  end
end
