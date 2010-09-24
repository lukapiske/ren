require 'test_helper'

class Admin::Renault::CarParksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_renault_car_parks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create car_park" do
    assert_difference('Admin::Renault::CarPark.count') do
      post :create, :car_park => { }
    end

    assert_redirected_to car_park_path(assigns(:car_park))
  end

  test "should show car_park" do
    get :show, :id => admin_renault_car_parks(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_renault_car_parks(:one).to_param
    assert_response :success
  end

  test "should update car_park" do
    put :update, :id => admin_renault_car_parks(:one).to_param, :car_park => { }
    assert_redirected_to car_park_path(assigns(:car_park))
  end

  test "should destroy car_park" do
    assert_difference('Admin::Renault::CarPark.count', -1) do
      delete :destroy, :id => admin_renault_car_parks(:one).to_param
    end

    assert_redirected_to admin_renault_car_parks_path
  end
end
