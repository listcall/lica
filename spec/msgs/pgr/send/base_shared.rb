# new_pgr

# required_by: msgs/pgr/send/email/base
# required_by: msgs/pgr/send/phone/base

def kp(env)
  klas.send :proxy_class, :double, env
end

shared_examples_for 'send/base' do
  describe 'Class Methods' do
    specify { expect(klas).to respond_to(:env_sender)              }
    specify { expect(klas).to respond_to(:proxies)                 }
    specify { expect(klas).to respond_to(:live_from_dev?)          }
  end
end