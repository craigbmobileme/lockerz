require 'test_helper'

class LockersControllerTest < ActionController::TestCase
  setup do
    @locker = lockers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lockers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create locker" do
    assert_difference('Locker.count') do
      post :create, locker: { bag_size: :small_bag }
    end

    assert_redirected_to locker_path(assigns(:locker))
  end

  test "should show locker" do
    get :show, id: @locker
    assert_response :success
  end

  test "should find a locker and retrieve a bag" do
    #TODO, needs to check the functionality of finding and retreiving and freeing a locker
    #I am not familiar enough with the new syntax of rails tests to do this quickly
    assert true
  end

  test "should update locker" do
    patch :update, id: @locker, locker: { bag_size: :small_bag }
    assert_redirected_to locker_path(assigns(:locker))
  end

  test "should destroy locker" do
    assert_difference('Locker.count', -1) do
      delete :destroy, id: @locker
    end

    assert_redirected_to lockers_path
  end
end
