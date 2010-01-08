require 'test/unit'
require 'acmscw'
module AcmScW
  module Business
    class BusinessServicesTest < Test::Unit::TestCase
      
      # Ensures that AcmScW is correctly loaded
      def setup
        AcmScW.load_configuration_file unless AcmScW.loaded?
      end
      
      def test_empty
      end
      
    end # class BusinessServicesTest
  end # module Business
end # module AcmScW