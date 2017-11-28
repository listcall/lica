class NavController < ApplicationController

  before_action :authenticate_member!

  def header
    render :layout => false
  end

  def admin
    render :layout => false
  end

  def footer
    render :layout => false
  end

end
