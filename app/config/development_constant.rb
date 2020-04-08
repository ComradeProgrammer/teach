module DevelopmentConstant
  GitLabHost = 'http://127.0.0.1:30000'.freeze
  # TeachHost = 'http://teach.ce:3000'.freeze
  TeachHost = 'http://127.0.0.1:3000'.freeze
  WebhookUrl = "#{TeachHost}/webhook".freeze

  # admin token
  PRIVATE_TOKEN = 'eBk9ioVVzPYfrp3JX2yw'.freeze

  # oauth application config
  APP_ID = '897bf428abefe85dca639ab99ec522c9e3b225552a6ed17c9e2b88862a86e023'.freeze
  APP_SECRET = 'bec37b6163b9f9cc59f2ff79c251afe362d1ea5198a7b225ae8684b2b69c2c22'.freeze
  REDIRECT_URI = "#{TeachHost}/oauth/callback".freeze
  ACCESS_TOKEN_URL = "#{GitLabHost}/oauth/token".freeze
end