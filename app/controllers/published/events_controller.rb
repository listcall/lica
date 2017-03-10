class Published::EventsController < ApplicationController

  respond_to :html, :json, :csv

  def index
    render text: 'OK'
  end

  def show
    render text: 'OK'
  end

end
