require 'test_helper'

class PageElementsControllerTest < ActionController::TestCase
  setup do
    @page_element = page_elements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_elements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_element" do
    assert_difference('PageElement.count') do
      post :create, page_element: {  }
    end

    assert_redirected_to page_element_path(assigns(:page_element))
  end

  test "should show page_element" do
    get :show, id: @page_element
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_element
    assert_response :success
  end

  test "should update page_element" do
    patch :update, id: @page_element, page_element: {  }
    assert_redirected_to page_element_path(assigns(:page_element))
  end

  test "should destroy page_element" do
    assert_difference('PageElement.count', -1) do
      delete :destroy, id: @page_element
    end

    assert_redirected_to page_elements_path
  end
end
