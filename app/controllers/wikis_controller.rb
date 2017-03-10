class WikisController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @wikis = current_team.wikis
  end

  def show
    @wiki = current_team.wikis.find(params[:id])
    @repo = @wiki.repo
  end

end
