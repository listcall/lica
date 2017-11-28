class CertsController < ApplicationController

  before_action :authenticate_member!

  def index
    @members = Rails.cache.fetch([current_team, 'teamCert']) do
      collection = current_team.memberships.active.by_rank_score
      MemberCertDecorator.decorate_collection(collection)
    end
  end

  def show

  end

end
