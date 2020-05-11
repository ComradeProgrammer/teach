class Constant
  if Rails.env == 'production'
    include ::ProductionConstant
  else
    include ::DevelopmentConstant
  end

  ReportToken = '8163fa799452df35b510089d56df1f285c60f36d'.freeze
  AUTO_TEST_RUNNER_HOST = '192.168.191.164:3001'.freeze
end