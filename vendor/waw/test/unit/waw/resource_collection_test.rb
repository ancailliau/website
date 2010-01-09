require 'waw'
require 'test/unit'
module Waw
  class ResourceCollectionTest < Test::Unit::TestCase
    
    def test_resources_on_string
      r = ResourceCollection.parse_resources <<-EOF
        first_one  "Hello world"
        second_one 2
        third_one 2*33
      EOF
      assert_equal "Hello world", r.first_one
      assert_equal 2, r.second_one
      assert_equal 66, r.third_one
    end
    
    def test_resources_on_file
      r = ResourceCollection.parse_resource_file(File.join(File.dirname(__FILE__), 'resources.txt'))
      assert_equal "Hello world", r.first_one
      assert_equal 2, r.second_one
      assert_equal 66, r.third_one
    end
    
    def test_on_missing_resources
      r = ResourceCollection.parse_resources <<-EOF
        first_one  "Hello world"
        second_one 2
        third_one 2*33
      EOF
      assert_equal nil, r.hello
    end
    
  end
end