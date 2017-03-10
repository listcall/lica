module Feature

  class Menu
    attr_accessor :label, :path, :owner, :manager, :active, :reserve, :guest
    def initialize(label = 'TBD', path = '/', owner = 'show', manager = 'show', active = 'show', reserve = 'show', guest = 'hide')
      @label      = label
      @path       = path
      @owner      = owner
      @manager    = manager
      @active     = active
      @reserve    = reserve
      @guest      = guest
    end
  end

  class Dependency
    attr_accessor :feature, :version
    def initialize(feature = 'TBD', version = '0.1')
      @feature = feature
      @version = version
    end
  end

  class Model

    include ActiveModel::Model

    attr_accessor :label, :name, :description, :author, :dependencies, :version, :menus

    alias_method :id, :label

    validates_presence_of :label, :name


    def initialize(params = {})
      opts = params || {}
      opts = default_values.merge(opts) if self.respond_to?(:default_values)
      @uuid = SecureRandom.uuid if self.respond_to?(:uuid)
      super(opts)
    end

    def to_h
      instance_variables.reduce({}) do |acc,val|
        key = val.to_s.gsub('@','')
        acc[key.to_sym] = eval("@#{key}")
        acc
      end
    end

    def add_menu(label: 'TBD', path: '/', visible_to: 'active')
      menus << Feature::Menu.new(label, path, visible_to)
    end

    def add_dependency(feature, version = '')
      depdencies << Feature::Dependency.new(feature, version)
    end

    def default_values
      {
          author:       'ListCall',
          description:  'TBD',
          dependencies: [],
          menus:        [],
          version:      '0.1'
      }
    end

  end
end
