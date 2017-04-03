require 'spec_helper'
require 'carpool'

# this is a simple demo of "Verifying Doubles" in rspec3
# see http://rhnh.net/2013/12/10/new-in-rspec-3-verifying-doubles

describe Carpool, '#suspend!' do

  it 'notifies the console' do
    notifier = instance_double('ConsoleNotifier')

    expect(notifier).to receive(:notify).with('suspended as')

    pool = described_class.new(notifier)
    pool.suspend!

  end

end

