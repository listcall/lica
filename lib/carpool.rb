# this is a simple demo of "Verifying Doubles" in rspec3
# see http://rhnh.net/2013/12/10/new-in-rspec-3-verifying-doubles


class Carpool < Struct.new(:notifier)

  def suspend!
    notifier.notify('suspended as')
  end

end

class ConsoleNotifier

  def notify(msg)
    puts msg
  end

end