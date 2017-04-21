# new_pgr

# required_by : msgs/pgr/send/email/proxy/letter_opener
# required_by : msgs/pgr/send/email/proxy/mandrill
# required_by : msgs/pgr/send/email/proxy/no_op
# required_by : msgs/pgr/send/sms/proxy/nexmo
# required_by : msgs/pgr/send/sms/proxy/no_op
# required_by : msgs/pgr/send/sms/proxy/plivo

shared_examples_for 'a sender proxy' do
  describe 'Accessors' do
    it { should respond_to :outbound          }
  end

  describe 'Instance Methods' do
    it { should respond_to :opts_from         }
    it { should respond_to :default_opts      }
    it { should respond_to :deliver           }
  end
end