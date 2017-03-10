class TeamWikiController < PolyBase::PagesController

  before_action :authenticate_reserve!

  private

  def base_path
    '/team_wiki'
  end

  def wiki_repo
    WikiRepo.where(name: current_team.acronym.upcase).to_a.first
  end

  def wiki_name
    'team_wiki'
  end

  def page_name
    params[:id]
  end

  def wiki_path
    base_path
  end

  def wiki_title
    current_team.name
  end

end
