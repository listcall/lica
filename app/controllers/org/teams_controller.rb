class Org::TeamsController < ApplicationController

  before_action   :authenticate_owner!
  before_action   :validate_enterprise_org!
  before_action   :validate_support_team!

  def index
    @org   = current_org
    @teams = @org.teams.field
  end

  def show
    @team = current_team
  end

  def new

  end

  def create

  end

  def edit

  end

  def update
    attrs = params['team']
    id = attrs.delete 'teamid'
    @team = Team.find id
    @team.update_attributes attrs.permit(:name, :logo_text, :altdomain, :subdomain, :icon)
    if @team.valid?
      port = env['SERVER_PORT'].blank? ? '' : ":#{env["SERVER_PORT"]}"
      new_url = "http://#{@team.subdomain}.#{@team.org.domain}#{port}/admin/team_names"
      redirect_to new_url, :notice => 'Successful Update'
    else
      flash.now[:error] = 'Not Updated'
      render :show
    end
  end

end
