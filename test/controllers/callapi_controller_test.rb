require 'test_helper'

class CallapiControllerTest < ActionController::TestCase
  test "should get getaccessuser" do
    get :getaccessuser
    assert_response :success
  end

end
