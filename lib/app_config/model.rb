require 'securerandom'
require 'json'

module AppConfig

  module ModelHelpers

    # use this if one of the attributes should act as the ID
    def id_attribute(method)

      define_method('id_field') do
        method
      end

      define_method('id') do
        send(method.to_s).to_s
      end

    end

    # use this if there is no attribute: it uses a generated UUID
    def id_uuid
      define_method('uuid') do
        id
      end
      define_method('uuid=') do |value|
        instance_variable_set '@uuid', value
      end
      define_method('id') do
        @uuid
      end
    end

    # use this instead of 'attr_accessor'
    def model_accessor(*field_syms)
      field_syms.each do |field_sym|

        field_str = field_sym.to_s

        # for dirty tracking (ActiveModel::Dirty)
        define_attribute_method field_sym

        # setter (using method syntax)
        define_method("#{field_str}=") do |val|
          # ----- dirty tracking -----
          old_val = instance_variable_get "@#{field_str}"
          chg_att = instance_variable_get('@changed_attributes') || {}
          instance_variable_set('@changed_attributes', chg_att.merge({field_sym => old_val}))
          # ----- set value -----
          instance_variable_set "@#{field_str}", val
        end

        # getter
        define_method(field_str) do
          instance_variable_get "@#{field_str}"
        end
      end
    end

  end

  class Model

    include ActiveModel::Model
    include ActiveModel::Dirty

    extend  ModelHelpers

    attr_accessor  :collection_obj
    attr_accessor  :position

    validates_numericality_of :position
    validates_presence_of     :position

    # ----- initialization -----

    def initialize(params = {})
      @collection_obj = params.delete(:collection_obj)
      opts      = params || {}
      opts      = default_values.merge(opts) if self.respond_to?(:default_values)
      @uuid     = SecureRandom.uuid if self.respond_to?(:uuid)
      @position = 0
      super(opts.except("validation_context"))
      @changed_attributes = {}
    end

    # ----- instance methods -----

    def to_h
      instance_variables.reduce({}) do |acc, val|
        unless %w(@collection_obj @changed_attributes).include?(val.to_s)
          acc[val.to_s.delete('@').to_sym] = instance_variable_get(val)
        end
        acc
      end
    end

    def to_json
      JSON.dump(to_h)
    end

    def assign_attributes(params)
      params.each do |k, v|
        send("#{k}=", v)
      end
    end

    def save
      @collection_obj.save unless @collection_obj.nil?
    end

    def save!
      @collection_obj.save! unless @collection_obj.nil?
    end

    # setter (using hash assignment syntax)
    def []=(field, val)
      instance_variable_set "@#{field.to_s}", val
      @collection_obj.add_obj(self) unless @collection_obj.nil?
    end

    #don't understand the purpose of this...
    def errors=(msg)
      dev_log('ERROR', msg) unless msg == {}
      msg
    end

  end

  private

  # collections and models are associated by class-name
  # collection class: TeamFeatures
  # model class:      TeamFeature
  def collection_klass
    eval self.class.name + 's'
  end

end

ActiveSupport.on_load('AppConfig::Model') { extend AppConfig::Model::ClassMethods }
