require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase
  setup do
    @broadcast = Broadcast.new
  end

  test "get json" do
    @broadcast.to_json
    assert true
  end
end
