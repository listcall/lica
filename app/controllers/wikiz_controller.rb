class WikizController < PolyBase::WikisController

  before_action :authenticate_reserve!

  def indexx
    @wiki_repos = WikiRepo.where(:primary_type => 'System')
  end

end
