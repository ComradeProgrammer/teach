class OrganizationsController < ApplicationController
  skip_before_action :require_login, only: [:get_all_info]

  def new

  end

  def create
    org_form = params[:org]
    model = Organization.new
    model.name = org_form['name']
    model.code = org_form['code']
    model.token = org_form['token']
    model.description = org_form['description']
    model.save
    redirect_to root_path
  end

  def index
    @all_org_info = Organization.all
  end

  def get_all_info
    res = []
    Organization.all.each do |item|
      res.append({name: item.name, code: item.code, token: item.token})
    end
    render json: res
  end
end
