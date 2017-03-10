module AppConfig
  module Accessor
    def config_accessor(*klas_syms)
      klas_syms.each do |sym|
        klas_str = sym.to_s             # e.g. "member_ranks"
        klas_cam = klas_str.camelize    # e.g. "MemberRanks"

        # setter
        define_method("#{klas_str}=") do |obj|
          _config_will_change!             # tell Rails to recognize an in-place change
          _config[klas_str] = obj.to_data  # update the field with the object's hash representation
        end

        # getter
        define_method(klas_str) do
          data = _config[klas_str] || {}       # get the collection from the json hash
          obj  = eval "#{klas_cam}.new(self)"  # create a new collection object
          if data.empty?                       # if there is no data
            obj.set_default_models             # load default models
          else                                 # else
            obj.load_data_from_db(data)        # load data from db
          end
          obj                                  # return the object
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) { extend AppConfig::Accessor }
