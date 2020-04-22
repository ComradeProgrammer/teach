require 'rest-client'
require 'json'

class AutoTestRunnersService
  def create_auto_test_point(project_id, input, expected_output)
    response = RestClient.post(auto_test_runner_host + '/create_auto_test_point', {
        :project_id => project_id,
        :input => input,
        :expected_output => expected_output
    })
    JSON.parser response.body
  end

  def start_auto_test(project_id, git_repo_list, use_text_file = nil,
                      compile_command = nil, exec_command = nil)
    payload = {
        :project_id => project_id,
        :git_repo_list => git_repo_list
    }

    if use_text_file
      payload[:use_text_file] = use_text_file
    end

    if compile_command
      payload[:compile_command] = compile_command
    end

    if exec_command
      payload[:exec_command] = exec_command
    end

    RestClient.post(auto_test_runner_host + '/start_auto_test', payload)
  end

  def get_auto_test_results(project_id)
    response = RestClient.get(auto_test_runner_host + '/get_auto_test_results', {
        :project_id => project_id
    })
    JSON.parse response.body
  end

  def auto_test_runner_host
    Constant::AUTO_TEST_RUNNER_HOST
  end
end
