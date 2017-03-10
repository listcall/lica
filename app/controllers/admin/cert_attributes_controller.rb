class Admin::CertAttributesController < ApplicationController

before_action :authenticate_owner!

  def index
    @title = 'Cert Attributes'
  end

end
