class BroadcastsController < ApplicationController
  # todo: add permission control

  def index
    print '>>>>>>>>>>>>>'
    user_id = User.find_by(gitlab_id: current_user.id).id
    print(user_id)
    @broadcasts = Broadcast.where(:to_id => user_id)
    @broadcasts.each do |item|
      print(item.content)
    end
  end

  def new
    @errors = []
    @broadcast = Broadcast.new
  end

  def create
    broadcast = Broadcast.new
    info = params[:broadcast]
    broadcast.from_id = current_user.id
    broadcast.to_id = info[:to_id]
    broadcast.content = info[:content]
    broadcast.save
    redirect_to(classrooms_path)
  end
end
