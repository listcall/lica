require 'app_config/collection'

class TeamNavHdrs < AppConfig::Collection

  def set_default_models
    return unless @collection.count == 0

    objs = []
    objs << TeamNav.new( type: 'Lica_Members'      , label: 'Members'      , path: '/members'      )
    objs << TeamNav.new( type: 'Lica_Paging'       , label: 'Paging'       , path: '/paging'       )
    objs << TeamNav.new( type: 'Lica_Events'       , label: 'Events'       , path: '/events'       )
    #objs << TeamNav.new( type: "Lica_Certs"        , label: "Certs"        , path: "/certs"        )
    #objs << TeamNav.new( type: "Lica_Forums"       , label: "Forums"       , path: "/forums"       )
    #objs << TeamNav.new( type: "<custom>"          , label: "Help"         , path: "/sys/wikis"    )
    #objs << TeamNav.new( type: "<custom>"          , label: "Wiki"         , path: "/team_wiki"    )
    #objs << TeamNav.new( type: "Lica_DutyOfc"      , label: "DutyOfc"      , path: "/duty_ofc"     )
    #objs << TeamNav.new( type: "Lica_Availability" , label: "Availability" , path: "/availability" )
    #objs << TeamNav.new( type: "Lica_Reports"      , label: "Reports"      , path: "/reports"      )
    self.add_obj *objs
    self
  end

end