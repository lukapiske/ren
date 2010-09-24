require 'test_helper'

class Admin::OutletsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_outlets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create outlet" do
    assert_difference('Admin::Outlet.count') do
      post :create, :outlet => { }
    end

    assert_redirected_to outlet_path(assigns(:outlet))
  end

  test "should show outlet" do
    get :show, :id => admin_outlets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_outlets(:one).to_param
    assert_response :success
  end

  test "should update outlet" do
    put :update, :id => admin_outlets(:one).to_param, :outlet => { }
    assert_redirected_to outlet_path(assigns(:outlet))
  end

  test "should destroy outlet" do
    assert_difference('Admin::Outlet.count', -1) do
      delete :destroy, :id => admin_outlets(:one).to_param
    end

    assert_redirected_to admin_outlets_path
  end
end
