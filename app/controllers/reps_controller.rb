class RepsController < ApplicationController

  before_action :authenticate_active!

  def show
    base_opts  = {team: current_team, member: current_membership}
    query_opts = params.slice(:month, :quarter, :year)
    @report = Rep::StiService.find(params[:id]).with_opts(base_opts, query_opts)
    render text: @report.template_content, layout: 'report'
  end
end

