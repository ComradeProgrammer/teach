require 'test_helper'

class AutoTestProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    auto_test_project = auto_test_projects(:one)
    classroom = auto_test_project.classroom
    @a_id = auto_test_project.id
    @c_id = classroom.id
  end

  test "should get show" do
    get classroom_auto_test_project_url(classroom_id: @c_id, id: @a_id)
    assert_equal 'show', @controller.action_name
  end

  test "should get feedback" do
    post feedback_classroom_auto_test_project_url(classroom_id: @c_id, id: @a_id, format: :json)
    assert_equal 'feedback', @controller.action_name
  end

  test "should get trigger" do
    post trigger_classroom_auto_test_project_url(classroom_id: @c_id, id: @a_id, format: :json)
    assert_equal 'trigger', @controller.action_name
  end

  test "should new" do
    get new_classroom_auto_test_project_url(
            :classroom_id => 1, :type => 'personal')
    assert_equal 'new', @controller.action_name
  end

  test "should create" do
    owner = User.new
    classroom = owner.classrooms.new
    # atp = classroom.auto_test_projects.new
    post classroom_auto_test_projects_url(:classroom_id => 1, :type => 'personal')
    assert_equal 'create', @controller.action_name
  end
end
