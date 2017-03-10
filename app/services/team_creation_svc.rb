# Public: Creates a team
#
# TODO: return Errors for integration with Rails forms
#
class TeamCreationSvc

  attr_accessor :opts

  def initialize(alt = {})
    @opts = {}
    @opts[:org_id]    = alt[:org_id]    || alt[:org].id || raise('Org Required')
    @opts[:acronym]   = alt[:acronym]   || raise('Acronym Required')
    @opts[:name]      = alt[:name]      || @opts[:acronym]
    @opts[:subdomain] = alt[:subdomain] || @opts[:acronym].downcase
    @opts[:logo_text] = alt[:logo_text] || @opts[:acronym]
    @opts[:icon]      = alt[:icon]
    @opts[:typ]       = 'field'
   end

  def create
    team = nil
    ActiveRecord::Base.transaction do
      team = Team.create @opts
    end
    team
  end

end