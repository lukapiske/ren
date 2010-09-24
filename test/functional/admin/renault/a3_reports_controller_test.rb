require 'test_helper'

class Admin::Renault::A3ReportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_renault_a3_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create a3_report" do
    assert_difference('Admin::Renault::A3Report.count') do
      post :create, :a3_report => { }
    end

    assert_redirected_to a3_report_path(assigns(:a3_report))
  end

  test "should show a3_report" do
    get :show, :id => admin_renault_a3_reports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_renault_a3_reports(:one).to_param
    assert_response :success
  end

  test "should update a3_report" do
    put :update, :id => admin_renault_a3_reports(:one).to_param, :a3_report => { }
    assert_redirected_to a3_report_path(assigns(:a3_report))
  end

  test "should destroy a3_report" do
    assert_difference('Admin::Renault::A3Report.count', -1) do
      delete :destroy, :id => admin_renault_a3_reports(:one).to_param
    end

    assert_redirected_to admin_renault_a3_reports_path
  end
end
