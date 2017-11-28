class QualsController < ApplicationController

  before_action :authenticate_member!

  def index
    @quals = current_team.quals  #.includes([:team, :qual_ctypes])
  end

  def show

  end

end
