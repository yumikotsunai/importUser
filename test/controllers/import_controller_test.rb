require 'test_helper'

class ImportControllerTest < ActionController::TestCase
  test "should get importcsv" do
    get :importcsv
    assert_response :success
  end

end
