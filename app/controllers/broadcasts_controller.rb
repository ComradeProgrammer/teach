=begin
This controller contains methods with broadcast, like basic resource method
and some helper methods like getting all students id, etc. (which are useful
in frontend while use a list to show all students number)
=end

class BroadcastsController < ApplicationController
  # todo: add permission control

  def index
    user_id = User.find_by(gitlab_id: current_user.id).id
    @broadcasts_ori = Broadcast.where(:to_id => user_id)
    @broadcasts = []
    @broadcasts_ori.each do |item|
      id = item.id
      name = User.find_by(id: item.from_id).username
      time = item.created_at.strftime("%Y-%m-%d %k:%M:%S")
      content = item.content
      @broadcasts.append({id: id, name: name, time: time, content: content})
    end
  end

  def new
    @errors = []
    @broadcast = Broadcast.new
  end

  def create
    type = params[:type]
    content = params[:content]
    class_id = params[:class_id]
    user_id = params[:user_id]
    from_user_id = User.find_by(gitlab_id: current_user.id).id

    if type == 'all'
      get_all_id_list.each do |item|
        broadcast = Broadcast.new
        broadcast.from_id = from_user_id
        broadcast.to_id = item
        broadcast.content = content
        broadcast.save
      end
    elsif type == 'all_students'
      get_all_students_id_list.each do |item|
        broadcast = Broadcast.new
        broadcast.from_id = from_user_id
        broadcast.to_id = item
        broadcast.content = content
        broadcast.save
      end
    elsif type == 'all_teachers'
      get_all_teachers_id_list.each do |item|
        broadcast = Broadcast.new
        broadcast.from_id = from_user_id
        broadcast.to_id = item
        broadcast.content = content
        broadcast.save
      end
    elsif type == 'class'
      get_class_all_id_list(class_id).each do |item|
        broadcast = Broadcast.new
        broadcast.from_id = from_user_id
        broadcast.to_id = item
        broadcast.content = content
        broadcast.save
      end
    elsif type == 'user'
      broadcast = Broadcast.new
      broadcast.from_id = from_user_id
      broadcast.to_id = user_id
      broadcast.content = content
      broadcast.save
    else
      redirect_to(classrooms_path)
    end
    redirect_to(classrooms_path)
  end

  def get_latest_broadcast
    user_id = User.find_by(gitlab_id: current_user.id).id
    user_broadcasts = Broadcast.where(:to_id => user_id)
    latest_broadcast = user_broadcasts[-1]
    return_dict = {broadcast_num: user_broadcasts.length, latest_broadcast: latest_broadcast}
    render json: return_dict
  end

  def destroy
    @broadcast = Broadcast.find(params[:id])
    @broadcast.destroy
    redirect_to broadcasts_path
  end

  def destroy_all
    user_id = User.find_by(gitlab_id: current_user.id).id
    Broadcast.where(:to_id => user_id).each do |item|
      item.destroy
    end
    redirect_to broadcasts_path
  end

  private

=begin
These private methods are used to display member list
at the frontend in different scopes (eg. all members/
all teachers/all students, etc.)
=end

  def get_all_id_list
    res = []
    User.all.each do |user|
      res.append(user.id)
    end
    res
  end

  def get_all_students_id_list
    res = []
    User.where(:role => 'student').each do |user|
      res.append(user.id)
    end
    res
  end

  def get_all_teachers_id_list
    res = []
    User.where(:role => 'teacher').each do |user|
      res.append(user.id)
    end
    res
  end

  def get_class_all_id_list(classroom_id)
    res = []
    SelectClassroom.where(:classroom_id => classroom_id).each do |sc|
      res.append(sc.user_id)
    end
    res
  end
end
