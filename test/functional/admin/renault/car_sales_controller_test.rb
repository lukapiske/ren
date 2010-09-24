require 'test_helper'

class Admin::Renault::CarSalesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_renault_car_sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create car_sale" do
    assert_difference('Admin::Renault::CarSale.count') do
      post :create, :car_sale => { }
    end

    assert_redirected_to car_sale_path(assigns(:car_sale))
  end

  test "should show car_sale" do
    get :show, :id => admin_renault_car_sales(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_renault_car_sales(:one).to_param
    assert_response :success
  end

  test "should update car_sale" do
    put :update, :id => admin_renault_car_sales(:one).to_param, :car_sale => { }
    assert_redirected_to car_sale_path(assigns(:car_sale))
  end

  test "should destroy car_sale" do
    assert_difference('Admin::Renault::CarSale.count', -1) do
      delete :destroy, :id => admin_renault_car_sales(:one).to_param
    end

    assert_redirected_to admin_renault_car_sales_path
  end
end
