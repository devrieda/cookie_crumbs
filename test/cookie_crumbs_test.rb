require File.dirname(__FILE__) + '/abstract_unit'

class CookieCrumbsTest < Test::Unit::TestCase

  # FAUX CONTROLLERS ========================================

  # Test controller to make requests to to test out our cookie setting methods
  class TestController < ActionController::Base
    attr_accessor :testvar1, :testvar2

    def set_single_cookie
      crumbs["user"] = "derek"
      render :nothing => true
    end

    def set_single_cookie_with_symbol
      crumbs[:user] = "derek"
      render :nothing => true
    end

    def set_single_cookie_with_hash
      crumbs[:user] = {:username => "derek", :password => "test"}
      render :nothing => true
    end

    def set_multiple_cookies
      crumbs[:user]    = "derek"
      crumbs[:comment] = "hey there"
      render :nothing => true
    end

    def get_single_cookie
      @testvar1 = crumbs["user"]
    end

    def get_single_cookie_by_symbol
      @testvar1 = crumbs[:user]
    end

    def get_multiple_cookies
      @testvar1 = crumbs[:user]
      @testvar2 = crumbs[:comment]
    end


    def set_single_crumb
      crumbs[:user]["username"] = "derek"
      render :nothing => true
    end

    def set_single_crumb_with_symbols
      crumbs[:user][:username] = "derek"
      render :nothing => true
    end

    def set_multiple_crumbs
      crumbs[:user][:username] = "derek"
      crumbs[:user][:password] = "test"
      render :nothing => true
    end

    def set_multiple_crumbs_with_equals
      crumbs[:user][:username] = "beer=good"
      crumbs[:user][:password] = "test"
      render :nothing => true
    end

    def delete_crumb
      crumbs[:user].delete :username
    end


    def get_single_crumb
      @testvar1 = crumbs[:user]["username"]
    end

    def get_single_crumb_by_symbol
      @testvar1 = crumbs[:user][:username]
    end

    def get_multiple_crumbs
      @testvar1 = crumbs[:user][:username]
      @testvar2 = crumbs[:user][:password]
    end

  end


  # TESTS ========================================
  def setup
    @request  = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @request.host = "www.derekdevries.com"
  end


  # TEST GETTERS ========================================

  def test_get_single_cookie
    self.request_cookies = {:user => "derek"}
    @request.action = "get_single_cookie"
    process_request

    assert_equal({"derek" => nil}, @controller.testvar1)
  end

  def test_get_single_cookie_by_symbol
    self.request_cookies = {:user => "derek"}
    @request.action = "get_single_cookie_by_symbol"
    process_request

    assert_equal({"derek" => nil}, @controller.testvar1)
  end

  def test_get_single_cookie_with_crumbs
    self.request_cookies = {:user => "username=derek|password=test"}
    @request.action = "get_single_cookie"
    process_request

    assert_equal({"username"=>"derek", "password"=>"test"}, @controller.testvar1)
  end

  def test_get_single_empty_cookie
    @request.action = "get_single_cookie"
    process_request

    assert_equal({}, @controller.testvar1)
  end

  def test_get_multiple_cookies
    self.request_cookies = {:user => "derek", :comment => "hey there"}
    @request.action = "get_multiple_cookies"
    process_request

    assert_equal({"derek"     => nil}, @controller.testvar1)
    assert_equal({"hey there" => nil}, @controller.testvar2)
  end


  def test_get_single_crumb
    self.request_cookies = {:user => "username=derek"}
    @request.action = "get_single_crumb"
    process_request

    assert_equal "derek", @controller.testvar1
  end

  def test_get_single_crumb_by_symbol
    self.request_cookies = {:user => "username=derek"}
    @request.action = "get_single_crumb_by_symbol"
    process_request

    assert_equal "derek", @controller.testvar1
  end

  def test_get_empty_crumb
    self.request_cookies = {:user => "password=test"}
    @request.action = "get_single_crumb"
    process_request

    assert_nil @controller.testvar1
  end

  def test_get_multiple_crumbs
    self.request_cookies = {:user => "username=derek|password=test"}
    @request.action = "get_multiple_crumbs"
    process_request

    assert_equal "derek", @controller.testvar1
    assert_equal "test",  @controller.testvar2
  end

  def test_get_multiple_crumbs_with_equal_signs
    self.request_cookies = {:user => "username=beer^^good|password=test"}
    @request.action = "get_multiple_crumbs"
    process_request

    assert_equal "beer=good", @controller.testvar1
    assert_equal "test",      @controller.testvar2
  end

  def test_delete_crumb
    self.request_cookies = {:user => "username=derek|password=test"}

    @request.action = "delete_crumb"
    assert_equal({"user" => "password=test"}, process_request.cookies)
  end


  # TEST SETTERS ========================================

  def test_set_single_cookie
    @request.action = "set_single_cookie"

    assert_equal({"user" => "derek"}, process_request.cookies)
  end

  def test_set_single_cookie_with_symbol
    @request.action = "set_single_cookie_with_symbol"
    assert_equal({"user" => "derek"}, process_request.cookies)
  end

  def test_set_single_cookie_with_hash
    @request.action = "set_single_cookie_with_hash"
    assert_equal({"user" => "password=test|username=derek"}, process_request.cookies)
  end

  def test_set_multiple_cookies
    @request.action = "set_multiple_cookies"
    assert_equal 2, process_request.cookies.size
  end

  def test_set_single_crumb
    @request.action = "set_single_crumb"
    assert_equal({ "user" => "username=derek" }, process_request.cookies)
  end

  def test_set_single_crumb_with_symbols
    @request.action = "set_single_crumb_with_symbols"
    assert_equal({"user" => "username=derek"}, process_request.cookies)
  end

  def test_set_multiple_crumbs
    @request.action = "set_multiple_crumbs"
    assert_equal({"user" => "username=derek|password=test"}, process_request.cookies)
  end

  def test_set_multiple_crumbs_with_equals
    @request.action = "set_multiple_crumbs_with_equals"
    assert_equal({"user" => "username=beer^^good|password=test"}, process_request.cookies)
  end


  private

  def request_cookies=(params)
    params.each do |key, value| 
      @request.cookies[key.to_s] = value.to_s
    end
  end
  
  def process_request
    @controller = TestController.new
    @controller.process(@request, @response)
  end
end
