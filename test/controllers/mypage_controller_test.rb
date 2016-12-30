require 'test_helper'

class MypageControllerTest < ActionController::TestCase
  test "should get top" do
    get :top
    assert_response :success
  end

  test "should get xxx" do
    get :xxx
    assert_response :success
  end

end
