# new_pgr

# required_by : msgs/dispatch/handler/forum
# required_by : msgs/dispatch/handler/password
# required_by : msgs/dispatch/handler/pgr
# required_by : msgs/dispatch/handler/unrecognized_sender

shared_examples_for 'a handler' do
  describe 'Accessors' do
    it { should respond_to :inbound           }
  end

  describe 'Instance Methods' do
    it { should respond_to :handle            }
  end
end