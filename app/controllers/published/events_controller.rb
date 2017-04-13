class Published::EventsController < ApplicationController

  respond_to :html, :json, :csv

  def index
    render plain: 'OK'
  end

  def show
    render plain: 'OK'
  end

end
