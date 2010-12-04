require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'



# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < Test::Unit::TestCase
 
fixtures :master_logins
fixtures :users
fixtures :roles
fixtures :roles_users
fixtures :actors
fixtures :people 
  def setup
    @controller = ProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_show
    
    get :show, :user_id => 1
    
    assert_redirected_to :controller => 'master_login',:action => 'index'
    get :login ,:master_login => "admin", :master_password => "4283"
    assert_redirected_to  :action => 'index'
    assert_response 302 #redirect
    
  end
  
end
