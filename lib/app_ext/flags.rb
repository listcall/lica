# this code comes from https://github.com/infinitysw/hstore_flags
# it provides simple boolean value for hstore field

module AppExt
  module Flags
    extend ActiveSupport::Concern
    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'show', 'on', 'ON']
    STORED_TRUE_VALUE = 'true'

    private

    def set_hstore_flag_field(field, flag, value)
      new_val = TRUE_VALUES.include?(value)
      old_val = send(flag)
      return if new_val == old_val

      send("#{field}_will_change!")
      if defined? changed_attributes
        # had to comment this out for Rails4.2
        # TODO - find a Rails4.2 compatible method
        # send(:changed_attributes).merge!(flag.to_s => old_val)
      end
      fields = self[field] || {}

      if new_val
        self[field] = fields.merge(flag.to_s => STORED_TRUE_VALUE)
      else
        fields.delete(flag.to_s)
        self[field] = fields
      end
      new_val
    end

    module ClassMethods
      def xfields_flags(*args)
        opts  = args.extract_options!
        field = opts[:field] || 'xfields'
        table_field = "#{self.table_name}." + field

        args.each do |flag|
          define_method("#{flag}")      {(self[field] || {})[flag.to_s] == STORED_TRUE_VALUE}
          define_method("#{flag}?")     {(self[field] || {})[flag.to_s] == STORED_TRUE_VALUE}
          define_method("not_#{flag}")  {(self[field] || {})[flag.to_s] != STORED_TRUE_VALUE}
          define_method("not_#{flag}?") {(self[field] || {})[flag.to_s] != STORED_TRUE_VALUE}
          define_method("#{flag}=")     {|val| set_hstore_flag_field(field, flag, val)}

          unless opts[:scopes] == false
            scope "#{flag}", -> { where("defined(#{table_field}, '#{flag}') IS TRUE") }
            scope "not_#{flag}", -> { where("defined(#{table_field}, '#{flag}') IS NOT TRUE") }

            class_eval <<-EVAL
            def self.#{flag}_condition
              "(defined(#{table_field}, '#{flag}') IS TRUE)"
            end

            def self.not_#{flag}_condition
              "(defined(#{table_field}, '#{flag}') IS NOT TRUE)"
            end
            EVAL
          end
        end
      end
      alias_method :xfield_flags, :xfields_flags
      alias_method :xfields_flag, :xfields_flags
      alias_method :xfield_flag , :xfields_flags
    end
  end
end

ActiveRecord::Base.send(:include, AppExt::Flags)
