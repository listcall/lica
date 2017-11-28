class Admin::CertAttributesController < ApplicationController

before_action :authenticate_member!

  def index
    @title = 'Cert Attributes'
  end

end
