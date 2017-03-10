class Mock::GearSvc

  attr_reader :data

  def initialize(data, wheel)
    @data  = data
    @wheel = wheel
  end

  def update_wheel
    @wheel = wheel.update(data)
  end

  private

  attr_reader :wheel

end