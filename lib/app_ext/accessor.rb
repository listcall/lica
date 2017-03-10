# integration_test: models/app_ext_tst

# work in progress...
class JfieldProxy
  def initialize(obj, col, key)
    @obj = obj
    @col = col
    @key = key
  end

  def [](key)
    @obj.send(@col)[@key]
  end

  def []=(key, value)
    @obj.send(@col)
  end
end

module AppExt

  module Accessor
    # the methods in this module replace array methods,
    # forcing the values to be upcased.
    module CapArray
      def <<(el)
        super(to_upcase(el))
      end

      def +(arr)
        newarr = Array(arr).map {|el| to_upcase(el)}
        super(newarr)
      end

      def concat(arr)
        newarr = Array(arr).map {|el| to_upcase(el) }
        super(newarr)
      end

      private

      def to_upcase(el)
        el.respond_to?(:upcase) ? el.upcase : el
      end
    end

    # forces upcase in a string field
    def upcase_fields(*fields)
      return if defined?(RAKE_ENV)
      fields.each do |field|
        field_key = field.to_s

        column = columns_hash[field_key]

        msg1 = "upcase_field - #{field_key} / #{column.type} "
        msg2 = 'must be :text or :string'
        raise(msg1 + msg2) unless %i(text string).include?(column.type)

        if column.array
          define_method("#{field_key}=") do |val|
            super(Array(val).map(&:upcase))
          end
          define_method(field_key) do
            self.attributes[field_key].extend(CapArray)
          end
        else
          define_method("#{field_key}=") do |val|
            super(val.try(:upcase))
          end
        end
      end
    end
    alias_method :upcase_field, :upcase_fields

    # First, add the appropriate fields to the migration:
    #     t.hstore   "xfields"  , default: {}
    # NB: don't forget the default empty hash!
    # Then in the AR Model:
    #     `require app_ext/accessor`
    #     `xfields_accessor   :field1, :field2, column: "xdata", default: "asdf"`
    #     `xfields_accessor   :field3, :field4`
    # Accessor names must be unique!
    # Column name default to "xfields", and can be over-ridden.
    # Convention is to use 'hstore' for xfields_accessor
    #
    def xfields_accessor(*fields, column: 'xfields', default: nil)
      fields.each do |field|
        field_key = field.to_s
        msg = "Xfields Accessor Error - method '#{field_key}' already defined"
        raise msg if method_defined?(field)

        # setter
        define_method("#{field_key}=") do |val|
          send "#{column}_will_change!"
          send("#{column}=", (send(column) || {}).merge({field_key => val}))
        end

        # getter
        define_method(field_key) do
          val = send(column)[field_key] || default
          val.is_a?(Hash) ? val.with_indifferent_access : val
        end
      end
    end
    alias_method :xfield_accessor, :xfields_accessor

    def jfields_accessor(*fields, column: 'jfields', default: nil)
      xfields_accessor *fields, column: column, default: default
    end
    alias_method :jfield_accessor, :jfields_accessor

    def jnested_accessor(*fields, column: 'jfields')
      fields.each do |field|
        field_key = field.to_s
        msg = "Jfields Accessor Error - method '#{field_key}' already defined"
        raise msg if method_defined?(field)

        # setter
        define_method("set_#{field_key}") do |hsh_key, val|
          send "#{column}_will_change!"
          new_hash = send(column)
          new_hash[field_key] ||= {}
          new_hash[field_key][hsh_key] = val
          send("#{column}=", new_hash)
        end

        # getter
        define_method("#{field_key}") do
          return {} if send(column).blank?
          val = send(column)[field_key] || {}
          val.is_a?(Hash) ? val.with_indifferent_access : val
        end
      end
    end

  end
end

ActiveSupport.on_load(:active_record) { extend AppExt::Accessor }
