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

  def add_runner
  end
end
