require File.dirname(__FILE__) + '/../test_helper'
require 'master_login_controller'

# Re-raise errors caught by the controller.
class MasterLoginController; def rescue_action(e) raise e end; end

class MasterLoginControllerTest < Test::Unit::TestCase
  def setup
    @controller = MasterLoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
