class BlogsController < ApplicationController
  before_action :check_classroom
  def score
    puts '-----------------------score'
    puts params
    blog = Blog.find(params[:blog_id])
    @blog_id = blog.id
    score_form = params[:score]
    puts score_form
  end
  def add_score
    puts params
    blog = Blog.find(params[:blog_id])
    score_form = params[:score]
    blog.score1 = score_form['score1']
    blog.score2 = score_form['score2']
    blog.save
    puts score_form
    redirect_to classroom_blogs_path
  end
  def index
    respond_to do |format|
      format.json do
        classroom = Classroom.find(params[:classroom_id])
        type_query = if search_params[:type] == 'all'
                       %w[blog daily_scrum]
                     else
                       search_params[:type]
                     end
        records = classroom.blogs
        if params[:team_project_id]
          team_project = TeamProject.find(params[:team_project_id])
          records = records.where(project_id: team_project.gitlab_id)
        end
        user = User.find_by(gitlab_id: current_user.id)
        user_projects = projects_service.all()
        pro_id = []
        user_projects.each do |pro|
          pro_id<<pro['id']
        end
        puts '-------------------'
        puts pro_id
        puts '--'
        puts records
        records = records.where(project_id:pro_id)
        puts '=='
        puts records
        if search_params[:scope] == 'my'
          blog_records = records.where(user_id: user.id, blog_type: type_query)
          #elsif search_params[:scope] == 'all' && user.role == 'student'
          #blog_records = records.where(user_id: user.id, blog_type: type_query)
        else
          blog_records = records.where(blog_type: type_query)
        end
        blogs = []
        blog_records.each do |br|
          puts br.project_id
          blog = blogs_service.get_blog br.project_id, br.gitlab_id
          blog['id'] = br.id
          blog['gitlab_id'] = br.gitlab_id
          project = admin_api_get "projects/#{br.project_id}"
          blog['project_name'] = project['name_with_namespace']
          blogs << blog
        end
        render json: blogs
      end
      format.html
    end
  end

  def new
    @homeworks = Homework.all.to_json
  end

  def show
    blog = Blog.find(params[:id])
    render_404 unless blog.classroom_id == params[:classroom_id].to_i
    @scores = {:score1 => blog.score1,:score2 => blog.score2}
    #puts "----------------------------"
    #puts blog
    #puts blog.title
    #puts blog.can_edit
  end

  def show_raw
    classroom = Classroom.find(params[:classroom_id])
    blog = classroom.blogs.find(params[:id])
    code = blogs_service.get_blog_raw_code blog.project_id, blog.gitlab_id
    render plain: code
  end
#新建博客
  def create
    classroom = Classroom.find(params[:classroom_id])
    new_blog = params[:blog]
    type = 'blog'
    if new_blog['file_name'] == 'daily_scrum.md'
      type = 'daily_scrum'
    end
    blog_record = classroom.blogs.new project_id: new_blog['project_id'], blog_type: type
    blog = blogs_service.new_blog new_blog
    blog_record.gitlab_id = blog['id']
    user = User.find_by(gitlab_id: current_user.id)
    blog_record.user_id = user.id
    blog_record.score1 = 0
    blog_record.score2 = 0
    blog_record.save
    redirect_to classroom_blogs_path
  end
#更新博客信息到gitlab
  def update
    respond_to do |format|
      format.json do
        classroom = Classroom.find(params[:classroom_id])
        blog_record = classroom.blogs.find(params[:id])
        update = params[:update]
        blog = blogs_service.update_blog blog_record.project_id, blog_record.gitlab_id, update
        render json: blog
      end
    end
  end
#删除博客
  def destroy
    respond_to do |format|
      format.json do
        classroom = Classroom.find(params[:classroom_id])
        blog = classroom.blogs.find(params[:id])
        res = blogs_service.delete_blog blog.project_id, blog.gitlab_id
        blog.destroy
        render plain: res
      end
    end
  end

  private

  def blogs_service
    ::BlogsService.new current_user
  end

  def search_params
    params.permit :type, :scope
  end
#检查访问博客的用户是否与博客在同一班级
  def check_classroom
    classroom = Classroom.find(params[:classroom_id])
    user = User.find_by(gitlab_id: current_user.id)
    unless classroom.users.include? user
      render_403
      return
    end
  end
  def projects_service
    ::ProjectsService.new current_user
  end
end
