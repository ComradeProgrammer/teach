class Constant
  if Rails.env == 'production'
    include ::ProductionConstant
  else
    include ::DevelopmentConstant
  end

  ReportToken = '8163fa799452df35b510089d56df1f285c60f36d'.freeze
  AUTO_TEST_RUNNER_HOST = '127.0.0.1:3001'.freeze
end