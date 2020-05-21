class RunnersController < ApplicationController
  def index
    @all_runners = Runner.all.to_json
    print(@all_runners)
  end

  def new

  end

  def show

  end

  def create

  end

  def add_runner_page
  end
``
  def add_runner
    runner = Runner.new
    runner[:name] = params[:name]
    runner[:path] = params[:path]
    runner[:os] = params[:os]
    runner[:uid] = params[:uid]
    begin
      runner.save!
    rescue => exception
      render json: {
        status: 500,
        err: :internal_server_error,
        messege: 'uid is not unique'
      }, status: 500
    end
  end
end
