require 'test_helper'

class Admin::Renault::BonusTargetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_renault_bonus_targets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bonus_target" do
    assert_difference('Admin::Renault::BonusTarget.count') do
      post :create, :bonus_target => { }
    end

    assert_redirected_to bonus_target_path(assigns(:bonus_target))
  end

  test "should show bonus_target" do
    get :show, :id => admin_renault_bonus_targets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_renault_bonus_targets(:one).to_param
    assert_response :success
  end

  test "should update bonus_target" do
    put :update, :id => admin_renault_bonus_targets(:one).to_param, :bonus_target => { }
    assert_redirected_to bonus_target_path(assigns(:bonus_target))
  end

  test "should destroy bonus_target" do
    assert_difference('Admin::Renault::BonusTarget.count', -1) do
      delete :destroy, :id => admin_renault_bonus_targets(:one).to_param
    end

    assert_redirected_to admin_renault_bonus_targets_path
  end
end
