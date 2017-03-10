class WikiReposController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @wiki_repo  = current_team.wiki_repos.first
    @wiki_repos = @wiki_repo.wiki_repos
  end

  def show
    @wiki_repo    = current_team.wiki_repos.first
    @wiki_repos   = @wiki_repo.wiki_repos
    @page_content = @wiki_repos.formatted_page_content(params[:id])
  end

end
