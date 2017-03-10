module AppConfig

  class Collection

    def initialize(ar_model = nil)
      reset_collection
      @ar_model     = ar_model
    end

    # ----- getters -----

    def [](key)
      @collection.find {|x| x.id == key}
    end
    alias_method :find, :[]

    def locate(attr, val)
      locate_all(attr, val).first
    end

    def locate_all(attr, val)
      return [] if count == 0
      method = attr.downcase.to_s
      return [] unless first.respond_to?(method)
      to_a.find_all {|item| item.send(method).to_s.downcase == val.to_s.downcase }
    end

    def count
      @collection.count
    end

    def keys
      to_a.map {|item| item.id}
    end

    def first
      to_a.first
    end

    def to_a
      @collection.sort { |x,y| x.position <=> y.position }
    end

    def to_h
      to_a.reduce({}) { |acc, val| acc[val.id] = val ; acc }
    end

    def to_data
      to_a.reduce({}) {|acc, val|  acc[val.id] = val.to_h; acc }
    end

    def reset_collection
      @collection = []
    end

    # ----- add models -----

    def set_obj(*models)
      reset_collection
      add_obj *models
    end

    def add_obj(*models)
      models.each do |mdl|
        mdl.instance_variable_set('@position'       , 0) if mdl.position.nil?
        mdl.instance_variable_set('@collection_obj' , self)
        @collection << mdl
      end
      reorder
      save
      self
    end

    def update_obj(*models)
      remove  *models
      add_obj *models
    end

    def set_data(data = {})
      reset_collection
      add_data(data)
    end

    def add_data(data = {})
      load_data_into_collection(data)
      save
      self
    end

    def load_data_from_db(data = {})
      load_data_into_collection(data)
      self
    end

    def create(params)
      model = model_klass.new(params)
      add(model)
    end

    # ----- save -----
    # if the collection has an associated ar_model,
    # save the collection data to the _config field
    # of the ar_model.
    def save
      unless @ar_model.nil?
        @ar_model._config_will_change!
        @ar_model._config[self.class.name.underscore] = self.to_data
      end
    end

    def save!
      save
      @ar_model.save unless @ar_model.nil?
    end


    # ----- destroy -----

    # remove a model from the collection and update the ordering
    def destroy(*values)
      remove(*values)
      reorder
      self
    end

    # ----- use method_missing for alternate call syntax -----
    #  original: team.member_ranks["TM"]
    # alternate: team.member_ranks.tm
    def method_missing(method)
      key_uc = keys.map {|x| x.upcase}
      mth_uc = method.to_s.upcase
      self.send(:find, mth_uc) if key_uc.include?(mth_uc)
    end

    private

    # remove a model from the collection
    def remove(*values)
      values.each do |value|
        @collection.delete_if { |model| model.id == value || model.id == value.try(:id) }
      end
    end

    # set the position value for each model in the collection
    def reorder
      to_a.each_with_index do |item, index|
        item.instance_variable_set('@position', index + 1)
      end
      self
    end

    # generate model objects from input hash data, then store
    # the model objects into the @collection instance variable
    def load_data_into_collection(data = {})
      tmp = data.reduce([]) do |acc, (_key, params)|
        model = model_klass.new(params.except("validation_context"))
        model.position = 0 if model.position.nil?
        model.collection_obj = self
        acc << model
        acc
      end
      @collection = @collection + tmp
      reorder
    end

    # collections and models are associated by class-name
    # collection class: TeamFeatures
    # model class:      TeamFeature
    def model_klass
      eval self.class.name[0..-2]
    end

  end

end
