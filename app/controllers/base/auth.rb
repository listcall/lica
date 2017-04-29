class ActionController::Base

  # ----- current-objects -----

  def current_org
    current_team.org
  end
  helper_method :current_org

  def current_team
    return nil if session[:team_id].blank?
    @current_team ||= Team.find(session[:team_id])
  end
  helper_method :current_team

  def current_memberships
    current_team && current_team.memberships
  end
  helper_method :current_memberships

  def current_membership
    return nil if current_team.nil?
    @current_membership ||= Membership.where(user_id: current_user.id, team_id: current_team.id).first if session[:user_id]
  end
  helper_method :current_membership

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  # ----- predicates -----

  def owner_rights?
    %w(owner).include? current_membership.try(:rights)
  end
  helper_method :owner_rights?

  def manager_rights?
    %w(owner manager).include? current_membership.try(:rights)
  end
  helper_method :manager_rights?

  def active_rights?
    %w(owner manager active).include? current_membership.try(:rights)
  end
  helper_method :active_rights?

  def reserve_rights?
    %w(owner manager active reserve).include? current_membership.try(:rights)
  end
  helper_method :reserve_rights?

  def guest_rights?
    %w(owner manager active reserve guest).include? current_membership.try(:rights)
  end
  helper_method :guest_rights?

  def alum_rights?
    %w(alum).include? current_membership.try(:rights)
  end
  helper_method :alum_rights?

  def inactive_rights?
    %w(inactive).include? current_membership.try(:rights)
  end
  helper_method :inactive_rights?

  def no_current_team? ; ! current_team ;  end
  helper_method :no_current_team?

  def valid_membership?; !current_membership.nil?  end
  def invalid_membership?; current_membership.nil?   end
  helper_method :valid_membership?, :invalid_membership?

  def user_signed_in?     ; !current_user.nil?  end
  def user_not_signed_in? ; current_user.nil?   end
  helper_method :user_signed_in?, :user_not_signed_in?

  # ----- team identification/selection -----

  def set_team_id
    return if [request.domain, request.subdomain] == [session[:team_domain], session[:team_subdomain]]
    org, team = TeamLocatorSvc.find(Org.base_domain(request.domain), request.subdomain)
    (dom_not_found       ; return false) if org.nil?
    (team_not_found(org) ; return false) if team.nil?
    session[:team_id]        = team.id
    session[:team_domain]    = request.domain
    session[:team_subdomain] = request.subdomain
  end

  def reset_team_session
    session[:team_id]        = ''
    session[:team_domain]    = ''
    session[:team_subdomain] = ''
  end

  def dom_not_found
    reset_team_session
    redirect_to "http://#{Org.fallback.try(:domain)}/info/domain_not_found"
  end

  def team_not_found(org)
    reset_team_session
    redirect_to "http://#{org.domain}/info/team_not_found"
  end

  # ----- authentication - team types -----
  def _validate_team(type)
    redirect_to('/info/no_feature') unless type == current_team.typ
  end

  def validate_field_team!   ; _validate_team('field')   ; end
  def validate_support_team! ; _validate_team('support') ; end

  def _validate_org(type)
    redirect_to('/info/no_feature') unless type == current_org.typ
  end

  def validate_enterprise_org! ; _validate_org('enterprise') ; end
  def validate_hosting_org!    ; _validate_org('hosting')    ; end
  def validate_system_org!     ; _validate_org('system')     ; end

  # ----- authentication - member types -----

  def _authenticate_member(role_test)
    return unless authenticate_user!
    redirect_to('/info/inactive') and return  if inactive_rights?
    redirect_to('/info/no_access') and return unless role_test
  end

  def authenticate_owner!
    _authenticate_member owner_rights?
  end

  def authenticate_manager!
    _authenticate_member manager_rights?
  end

  def authenticate_active!
    _authenticate_member active_rights?
  end

  def authenticate_reserve!
    _authenticate_member reserve_rights?
  end

  def authenticate_guest!
    _authenticate_member guest_rights?
  end

  def authenticate_user!
    if user_signed_in?
      return true
    else
      session[:tgt_subdomain] = request.subdomain
      session[:tgt_path]      = request.url
      redirect_to '/login', :alert => 'You must log in to access this page'
      return false
    end
  end

  # ----- api authentication -----

  # can be called with curl using http_basic authentication
  # curl -u user_name:pass http://bamru.net/reports
  # curl -u user_name:pass http://bamru.net/reports/BAMRU-report.csv
  #    note: user_name should be in the form of user_name, not user.name
  def authenticate_member_with_basic_auth!
    member = authenticate_with_http_basic do |u, p|
      Membership.find_by_user_name(u).authenticate(p)
    end
    if member
      session[:membership_id] = member.id
    else
      authenticate_api_member!
    end
  end

  def authenticate_api_member!
    unless member_signed_in?
      render :plain => 'Access Denied', :status => :unauthorized
    end
  end

  def authenticate_mobile_member!(redirect_url = mobile_login_url)
    unless member_signed_in?
      session[:tgt_path] = request.url
      redirect_to redirect_url, :alert => 'You must first log in to access this page'
    end
  end
end
