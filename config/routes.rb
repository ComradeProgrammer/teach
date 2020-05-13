Rails.application.routes.draw do
  get 'users/new'
  get 'users/destroy'
  root 'pages#main'

  # system hook for add system-wide webhook
  post '/system', to: 'system#index'

  # webhook for every project
  post '/webhook', to: 'webhook#index'

  # report interface for receive auto test result
  post '/report', to: 'report#index'

  # oauth application
  get '/login', to: 'sessions#login'
  get '/oauth/callback', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  resources :issues do
    collection do
      # 全量 issues
      get 'all', to: 'issues#all_issues', constraints: ->(req) { req.format == :json }
    end
  end

  resources :sprints

  resources :projects, only: [], param: :project_id do
    member do
      # project board
      get 'kanban', to: 'boards#index'
      # file upload
      post 'uploads', to: 'uploads#index'

      get 'labels', to: 'projects#labels', constraints: ->(req) { req.format == :json }

      get 'members', to: 'projects#members', constraints: ->(req) { req.format == :json }
    end
  end

  resources :milestones, only: [], param: :milestone_id do
    member do
      # milestone board
      get 'kanban', to: 'boards#index'
      # burndown chart
      get 'burndown', to: 'burndown#index'
    end
  end

  # teachers
  post '/classrooms/:id/edit', to: 'classrooms#update'
  resources :classrooms do
    collection do
      resources :auto_test_projects, only: [] do
        collection do
          post 'create_private_personal_project', to: 'auto_test_projects#create_private_personal_project'
        end
      end
    end
    resources :users, only: %i[new create destroy edit update]
    resources :auto_test_projects, only: %i[index new create show destroy] do
      collection do
        get 'batch_create', to: '#'
        get 'new_private_personal_project', to: '#'
        get 'new_pair_projects_batch', to: '#'
        get 'create_auto_test_point', to: 'auto_test_projects#new_auto_test_point'
        post 'create_auto_test_point', to: 'auto_test_projects#create_auto_test_point'
        get 'start_auto_test', to: 'auto_test_projects#new_start_auto_test'
        post 'start_auto_test', to: 'auto_test_projects#start_auto_test'

        post 'get_auto_test_repo', to: 'auto_test_projects#get_auto_test_repo'

        get 'get_auto_test_results', to: 'auto_test_projects#get_auto_test_results'
        get 'get_auto_test_points', to: 'auto_test_projects#get_auto_test_points'
        get 'remove_auto_test_point', to: 'auto_test_projects#remove_auto_test_point'
        # post 'create_private_personal_project', to: 'auto_test_projects#create_private_personal_project'
      end

      member do
        post 'feedback', to: 'auto_test_projects#feedback'
        post 'trigger', to: 'auto_test_projects#trigger'
      end
    end

    resources :team_projects, only: %i[show new create] do
      resources :blogs do
        member do
          get 'raw', to: 'blogs#show_raw'
        end
      end
      get 'insight', to: 'insight#show'

      collection do
        resources :team_events
      end
    end

    resources :blogs do
      member do
        get 'raw', to: 'blogs#show_raw'
      end
    end

    collection do
      get 'get_all_student_id_and_name', to: 'classrooms#get_all_student_id_and_name'
      get 'get_all_classroom_id_and_name', to: 'classrooms#get_all_classroom_id_and_name'
    end

    member do
      get 'join', to: 'classrooms#join'
      get 'exit', to: 'classrooms#exit'
    end
  end

  resources :blogs, only: [] do
    resources :comments, only: %i[index create update destroy], constraints: ->(req) { req.format == :json }
  end

  resource :users, only: [] do
    collection do
      get 'get_all_user_id_and_name', to: 'users#get_all_user_id_and_name'
      get 'get_classroom_user_id_and_name', to: 'users#get_classroom_user_id_and_name'
    end
  end

  resource :auto_test_projects, only: [] do
    collection do
      get 'get_personal_project_status', to: 'auto_test_projects#get_personal_project_status'
    end
  end

  resources :broadcasts do
    collection do
      get 'destroy_all', to: 'broadcasts#destroy_all'
    end
  end

  resources :organizations do
    collection do
      get 'get_all_info', to: 'organizations#get_all_info'
    end
  end
  resources :members do
    collection do
      get 'get_all_info',to: 'members#get_all_info'
    end
  end
end
