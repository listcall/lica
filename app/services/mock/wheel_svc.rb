class Mock::WheelSvc

  def update(data)
    @data = data
  end

  attr_reader :data

end