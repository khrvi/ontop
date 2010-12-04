require "#{File.dirname(__FILE__)}/../test_helper"

class ProfileTest < ActionController::IntegrationTest
  # fixtures :your, :models
fixtures :master_logins
fixtures :users
fixtures :roles
fixtures :roles_users
fixtures :actors
fixtures :people 
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_show
  
    get "/profile/show", :user_id => 1
    #Master login registration
    assert_redirected_to :controller => 'master_login',:action => 'index'
    post_via_redirect "/master_login/login" , :master_login => "admin", :master_password => "4283"
    assert_response  :success
    assert_template "home/index"
    #Check entering to "/profile/show" without autorezation 
    get "/profile/show", :user_id => 1
    assert_response  500
    #Check entering to "/profile/show" after autorezation
    post_via_redirect "/session/create" , :login => "admin", :password => "4283"
   # assert_equal "Login подтверждён" , flash[:notice]
    assert_response  :success
    assert_template "profile/show"
    
  end
  
end
