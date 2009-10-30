require 'test/unit'
require 'waw'
module Waw
  class ActionControllerTest < Test::Unit::TestCase
    
    class MyMailController < Waw::ActionController
      
      def this_is_possible
      end
      
      validate :mail, Waw::Validation::EMAIL, :invalid_email
      action_define :subscribe, [:mail] do |mail|
        this_is_possible
        :ok
      end
      
      def not_an_action
      end
      
    end
    
    def setup
      @controller = MyMailController.new
    end
    
    def test_controller_installation
      assert @controller.respond_to?(:subscribe)
      assert @controller.respond_to?(:action_subscribe)
      assert @controller.respond_to?(:not_an_action)
      assert_equal false, @controller.respond_to?(:action_not_an_action)
    end
    
    def test_controller_subscribe
      assert_equal :ok, @controller.subscribe("blambeau@gmail.com")
      assert_equal :invalid_email, @controller.subscribe("blambeau_gmail.com")
      assert_equal :invalid_email, @controller.subscribe(nil)
    end
    
    def test_controller_action_subscribe
      assert (/^[a-z]+@[a-z]+\.[a-z]/ =~ "blambeau@gmail.com")
      assert_equal :ok, @controller.action_subscribe({:mail => "blambeau@gmail.com"}, nil)
      assert_equal :invalid_email, @controller.action_subscribe({:mail => "blambeau_gmail.com"}, nil)
      assert_equal :invalid_email, @controller.action_subscribe({}, nil)
    end
    
    def test_controller_action_execute
      assert_equal :ok, @controller.execute({:action => 'subscribe', :mail => "blambeau@gmail.com"}, nil)
      assert_equal :ok, @controller.execute({:action => '/services/subscribe', :mail => "blambeau@gmail.com"}, nil)
      assert_equal :invalid_email, @controller.execute({:action => '/services/subscribe', :mail => "blambeau_gmail.com"}, nil)
    end
    
  end
end