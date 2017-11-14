module Feature

  class Collection

    def initialize
      @collection   = {}
    end

    def model_klass
      Feature::Model
    end

    def [](key)
      @collection[key]
    end

    def find(key)
      @collection[key]
    end

    def count
      @collection.count
    end

    def keys
      to_a.map {|item| item.id}
    end

    def to_a
      @collection.map {|_,v| v}.sort { |x,y| x.name <=> y.name }
    end

    def to_h
      to_a.reduce({}) { |acc, val| acc[val.id] = val ; acc}
    end

    def to_data
      to_a.reduce({}) {|acc, val|  acc[val.id] = val.to_h; acc}
    end

    def set_obj(*models)
      @collection = {}
      add_obj *models
    end

    def add_obj(*models)
      models.each do |mdl|
        @collection[mdl.id] = mdl
      end
      reorder
      self
    end

    def set_data(data = {})
      @collection = {}
      add_data(data)
    end

    def add_data(data = {})
      data = {} if data.nil?
      hash = data.reduce({}) do |acc, (_key, params)|
        model = model_klass.new(params)
        acc[model.id] = model
        acc
      end
      @collection = @collection.merge(hash)
      reorder
      self
    end

    def destroy(key)
      @collection.delete key.try(:id) || key
      reorder
      self
    end

    def reorder
      self
    end

    def reposition_on
    end

    def create(params)
      model = model_klass.new(params)
      add(model)
    end

    def default_models
      membr_des = 'Member roster, photo gallery and data export'
      avail_des = 'Member availability'
      event_des = 'Team events with rosters, time-tracking, attachments and reporting'
      posit_des = 'Recurring positions: scheduling and execution'
      pagng_des = 'Team Paging via Email / SMS'
      certs_des = 'Member Certifications'
      quals_des = 'Member Training Qualifications Tracking'
      repor_des = 'Database Reports'
      proto_des = 'Prototype: Under Construction'

      membr_men = [Feature::Menu.new('Members'         , '/members'               )]
      avail_men = [Feature::Menu.new('Availability'    , '/avail/days'            )]
      event_men = [Feature::Menu.new('Events'          , '/events'                )]
      posit_men = [Feature::Menu.new('Positions'       , '/positions'             )]
      pagng_men = [Feature::Menu.new('Paging'          , '/paging'                )]
      certs_men = [Feature::Menu.new('Certifications'  , '/certs'                 )]
      quals_men = [Feature::Menu.new('Qualifications'  , '/quals'                 )]
      repor_men = [Feature::Menu.new('Reports'         , '/reports'               )]
      proto_men = [Feature::Menu.new('Prototype'       , '/prototype'             )]

      objs = []
      objs << Feature::Model.new( label: 'Lica_Members'         , name: 'Members'         , description: membr_des , menus: membr_men )
      objs << Feature::Model.new( label: 'Lica_Availability'    , name: 'Availability'    , description: avail_des , menus: avail_men )
      objs << Feature::Model.new( label: 'Lica_Paging'          , name: 'Paging'          , description: pagng_des , menus: pagng_men )
      objs << Feature::Model.new( label: 'Lica_Events'          , name: 'Events'          , description: event_des , menus: event_men )
      objs << Feature::Model.new( label: 'Lica_Positions'       , name: 'Positions'       , description: posit_des , menus: posit_men )
      objs << Feature::Model.new( label: 'Lica_Certifications'  , name: 'Certifications'  , description: certs_des , menus: certs_men )
      objs << Feature::Model.new( label: 'Lica_Qualifications'  , name: 'Qualifications'  , description: quals_des , menus: quals_men )
      objs << Feature::Model.new( label: 'Lica_Reports'         , name: 'Reports'         , description: repor_des , menus: repor_men )
      objs << Feature::Model.new( label: 'Lica_Prototype'       , name: 'Prototype'       , description: proto_des , menus: proto_men )
      objs        #
    end

    def set_default_models
      self.set_obj *default_models
      self
    end
  end
end
