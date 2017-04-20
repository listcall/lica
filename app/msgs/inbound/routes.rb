Inbound::RouteMap.config do

  set_default_class Inbound::Error::ClassDefault

  set_base_module   Inbound::Error

  rules_for 'programmer errors' do
    use('ClassBlank').when       { |inbound| inbound.blank?             }
    use('ClassInvalid').unless   { |inbound| inbound.is_an_inbound?     }
    use('DestinationBlank').when { |inbound| inbound.destination.blank? }
  end

  rules_for 'inbound address errors' do
    use('OriginEmailUnregistered').unless { |inb| inb.orig_email_registered? }
    use('OriginSmsUnregistered').unless   { |inb| inb.orig_phone_registered? }
    use('OriginEmailNonmember').unless    { |inb| inb.orig_email_allowed?    }
    use('OriginSmsNonmember').unless      { |inb| inb.orig_phone_allowed?    }
    use('DestinationEmailInvalid').unless { |inb| inb.dest_email_valid?      }
  end

  set_base_module Inbound::Handler

  rules_for 'pager messages' do
    use('PgrSmsReply').when {  |inbound| inbound.is_sms? }
    use('PgrEmailReply').when do |inbound|
      inbound.is_email? && inbound.to_pager?
    end
    use('PgrEmailNew').when { |inbound| inbound.is_email? }
  end
end