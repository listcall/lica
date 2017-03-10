# new_pgr

# class Pgr::Send::Phone::Proxy::Nexmo
#
#   include Sms::SmsRenderable
#
#   attr_reader :outbound
#
#   def initialize(outbound = nil)
#     @outbound = outbound
#   end
#
#   def opts_from(outbound = nil)
#     "OK"
#   end
#
#   def default_opts
#     {}
#   end
#
#   def deliver
#     render_sms do |svc_number, mem_number|
#       devlog "STARTING SMS-NexmoSender TO: #{mem_number} FM: #{svc_number}"
#
#       params = {
#         to:   mem_number,
#         from: svc_number,
#         text: @outbound.msg_text
#       }
#
#       client = Nexmo::Client.new(NEXMO_SMS_KEY, NEXMO_SMS_SECRET)
#       _response = client.send_message(params)
#       devlog _response.object
#       devlog "END SMS-NexmoSender"
#     end
#   end
#
# end