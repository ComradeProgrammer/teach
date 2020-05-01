require 'test_helper'

class BroadcastsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
    get broadcasts_path
    assert_equal 'index', @controller.action_name
  end

  test "should new" do
    get new_broadcast_path
    assert_equal 'new', @controller.action_name
  end
end
