require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/person_controller'

# Re-raise errors caught by the controller.
class Admin::PersonController; def rescue_action(e) raise e end; end

class Admin::PersonControllerTest < Test::Unit::TestCase
  fixtures :actors

  def setup
    @controller = Admin::PersonController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = actors(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:actors)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:actors)
    assert assigns(:actors).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:actor)
  end

  def test_create
    num_actors = Actor.count

    post :create, :actor => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_actors + 1, Actors.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:actor)
    assert assigns(:actor).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Actor.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Actor.find(@first_id)
    }
  end
end
