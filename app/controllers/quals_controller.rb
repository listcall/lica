class QualsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @quals = current_team.quals  #.includes([:team, :qual_ctypes])
  end

  def show

  end

end
