module AuthlogicFacebookShim
  module Session  
    module Adapter
      Dir[File.expand_path('../adapters/*.rb', File.dirname(__FILE__))].each do |adapter|
        class_name = File.basename(adapter).rpartition(/_adapter\.rb$/).shift.camelize
        if defined?(class_name)
          require adapter
          include AuthlogicFacebookShim::Adapters.const_get("#{class_name}Adapter")
          break
        end
      end
      
    end
  end
end