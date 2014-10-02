require 'test_helper'

class CouncilsControllerTest < ActionController::TestCase
  setup do
    @council = councils(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:councils)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create council" do
    assert_difference('Council.count') do
      post :create, council: {  }
    end

    assert_redirected_to council_path(assigns(:council))
  end

  test "should show council" do
    get :show, id: @council
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @council
    assert_response :success
  end

  test "should update council" do
    patch :update, id: @council, council: {  }
    assert_redirected_to council_path(assigns(:council))
  end

  test "should destroy council" do
    assert_difference('Council.count', -1) do
      delete :destroy, id: @council
    end

    assert_redirected_to councils_path
  end
end
