class Published::TeamDirectoryController < ApplicationController

  def index
    @teams     = current_org.teams.field.published
    team_ids   = @teams.map {|x| x.id}
    @events    = Event.where(team_id: team_ids).between(Time.now, Time.now + 2.years).published
    @style_src = params['style-src']
    respond_to do |format|
      format.html { render layout: false        }
      format.css  { render partial: 'style.css' }
    end
  end

  def show
    @base_url = NavBarSvc.team_url(current_team, request.env)
    render layout: false
  end

end