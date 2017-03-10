require 'delivery_method/mailgun_dm'
require 'delivery_method/opener_dm'
require 'delivery_method/noop_dm'

ActionMailer::Base.add_delivery_method :mailgun_dm,  DeliveryMethod::MailgunDm
ActionMailer::Base.add_delivery_method :opener_dm,   DeliveryMethod::OpenerDm
ActionMailer::Base.add_delivery_method :noop_dm,     DeliveryMethod::NoopDm
