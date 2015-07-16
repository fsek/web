Fsek::Application.routes.draw do
  # Resources on the page
  get('/vecktorn', to: redirect('http://fsektionen.us11.list-manage.com/subscribe?u=b115d5ab658a971e771610695&id=f1fbd74cac'),
                   as: :vecktorn_signup, status: 301)
  get '/farad', to: redirect('http://www.farad.nu'), as: :farad, status: 301
  get '/facebook', to: redirect('https://www.facebook.com/Fsektionen'), as: :facebook, status: 301
  get '/twitter', to: redirect('https://www.twitter.com/Fsektionen'), as: :twitter, status: 301
  get '/youtube', to: redirect('https://www.youtube.com/user/fsektionen'), as: :youtube, status: 301

  get :about, controller: :static_pages, path: :om, as: :om
  get 'foretag/om', controller: :static_pages, action: :company_about, as: :company_about
  get 'foretag/vi-erbjuder', controller: :static_pages, action: :company_offer, as: :company_offer

  # User-related routes
  devise_for :users, skip: [:sessions, :registrations], controllers: {registrations: "registrations"}
  devise_scope :user do
    get 'avbryt_reg' => 'registrations#cancel', as: :cancel_user_registration
    post 'anvandare/skapa' => 'registrations#create', as: :user_registration
    get 'anvandare/registrera' => 'registrations#new', as: :new_user_registration
    # delete 'anvandare/ta_bort/:id' => 'users#destroy', :as => :admin_destroy_user

    #sessions
    get 'logga_in' => 'devise/sessions#new', as: :new_user_session
    post 'logga_in' => 'devise/sessions#create', as: :user_session
    delete 'logga_ut' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  # Scope to change urls to swedish
  scope path_names: {new: 'ny', edit: 'redigera'} do
    namespace :admin do
      resources :users, path: :anvandare, only: [:index] do
        post :member, on: :member
        post :unmember, on: :member
      end
    end

    resource :user, path: :anvandare, as: :own_user, only: [:update] do
      get '', action: :edit, as: :edit
      patch :password, path: :losenord, action: :update_password
      patch :account, path: :konto, action: :update_account
    end

    resources :users, path: :anvandare, only: [:show] do
      get :avatar, on: :member
    end

    resources :constants

    namespace :admin do
      resources :cafe_works, path: :hilbertcafe do
        patch :add_worker, path: :jobbare, on: :member
        patch :update_worker, path: :uppdatera, on: :member
        patch :remove_worker, path: :inte_jobba, on: :member
        get :overview, path: :oversikt, on: :collection
        get :setup, as: :setup, on: :collection
        post :setup_create, on: :collection
      end
    end

    resources :cafe_works, path: :hilbertcafe, only: [:index, :show] do
      get :edit, path: :jobba, on: :member
      patch :add_worker, path: :jobbare, on: :member
      patch :update_worker, path: :jobba, on: :member
      patch '', action: :remove_worker, on: :member, as: :remove_worker
      get :nyckelpiga, on: :collection
    end

    namespace :admin do
      resources :rents, path: :bilbokning, except: :edit do
        get :preview, path: :visa, on: :member
      end
    end

    resources :rents, path: :bilbokning, except: :index do
      collection do
        get :oversikt, action: :index, as: :overview
        get '', action: :main, as: :main
        post :check_dates
      end
    end

    resources :notices, path: :notiser do
      post :display, path: :visa, on: :member
      get :image, path: :bild, on: :member
    end

    resources :menus, path: :meny, except: :show

    resources :pages, path: :sida do
      resources :page_elements, path: :element, except: :show
    end

    resources :posts, path: :poster, only: :index do
      get :display, on: :member
      get :collapse, on: :collection
      post :add_user, on: :collection
      delete 'user/:post_user_id', on: :collection, action: :remove_user,
                                   as: :remove_user
      collection do
        get :show_permissions
      end
    end

    # Namespace for Nollning
    namespace :nollning do
      get '', controller: :nollnings, action: :index
      get :matrix, controller: :nollnings, action: :matrix, path: :matris
      post "modal/:date", controller: :nollnings, action: :modal, as: :event
      get "modal/:date", controller: :nollnings, action: :modal, as: :get_event
    end

    resources :councils, path: :utskott do
      resources :posts, path: :poster do
        patch :remove_user, on: :member
        patch :add_user, on: :member
      end
      resource :page, path: :sida do
        resources :page_elements, path: :element
      end
    end

    resources :faqs, path: :faq

    resources :contacts, path: :kontakt do
      post :mail, on: :member
    end

    resources :calendars, path: :kalender,  only: :index do
      get :export, on: :collection
    end

    resources :events, only: :show, path: :evenemang

    namespace :admin do
      resources :events, path: :evenemang
    end

    resources :work_posts, path: :jobbportal, except: :show

    resources :news, path: :nyheter

    resources :documents, path: :dokument


    namespace :admin do
      resources :elections, path: :val do
        get :nominations, path: :nomineringar, on: :member
        get :candidates, path: :kandideringar, on: :member, except: [:update]
      end
    end

    resources :elections, path: :val, only: :index do
      collection do
        resources :nominations, controller: 'elections/nominations',
                                path: :nominera, only: [:create] do
          get '', action: :new, on: :collection, as: :new
        end
        resources :candidates, controller: 'elections/candidates',
                               path: :kandidera, except: :edit
      end
    end

    namespace :admin do
      namespace :gallery, path: :galleri do
        resources :albums, path: :album, except: :edit do
          delete :destroy_images, on: :member
          resources :images, path: :bild, only: [:destroy, :show] do
            get :download, path: :hamta, on: :member
          end
        end
      end
    end

    get :galleri, controller: :gallery, action: :index, as: :gallery
    namespace :gallery, path: :galleri do
      resources :albums, path: :album, only: [:show]
    end

    namespace :admin do
      resources :permissions, only: [] do
        get '/:post_id', action: :show_post, on: :collection, as: :post
        patch '(/:post_id)', action: :update_post, on: :collection, as: :update
        get '', action: :index, on: :collection, as: :index
      end
    end
  end

  resources :short_links, except: [:show, :update, :edit] do
    collection do
      get 'go' => 'short_links#go'
      get 'check' => 'short_links#check'
    end
  end

  get 'proposals/form' => 'proposals#form'
  post 'proposals/generate' => 'proposals#generate'

  root 'static_pages#index'

  # Catch-all for short links.
  # This must be at the bottom!
  get '*link' => 'short_links#go'
end
