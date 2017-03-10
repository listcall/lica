class ActionController::Base

  def current_ability
    @current_ability ||= Ability.new(current_membership)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = 'Access Denied.'
    redirect_to root_url
  end

  helper_method

end