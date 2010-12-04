require File.dirname(__FILE__) + '/../../test_helper'
require 'util/selection_dialog_controller'

# Re-raise errors caught by the controller.
class Util::SelectionDialogController; def rescue_action(e) raise e end; end

class Util::SelectionDialogControllerTest < Test::Unit::TestCase
  def setup
    @controller = Util::SelectionDialogController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
