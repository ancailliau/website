module AcmScW
  class JSGeneration
    
    # Generates Javascript messages
    def self.generate_js_messages(output=STDOUT)
      AcmScW.load_configuration_file unless AcmScW.loaded?
      output << "var messages = new Array();\n"
      AcmScW::MESSAGES.each_pair do |key, message|
        output << "messages['#{key}'] = \"#{message}\"\n"
      end
    end
    
  end
end