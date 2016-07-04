Fsek::Application.routes.draw do
  filter :locale, exclude: /^\/admin/
  # Resources on the page
  get('/vecktorn', to: redirect('http://fsektionen.us11.list-manage.com/subscribe?u=b115d5ab658a971e771610695&id=aeb6a02396'),
                   as: :vecktorn_signup, status: 301)
  get '/farad', to: redirect('http://www.farad.nu'), as: :farad, status: 301
  get '/facebook', to: redirect('https://www.facebook.com/Fsektionen'), as: :facebook, status: 301
  get '/twitter', to: redirect('https://www.twitter.com/Fsektionen'), as: :twitter, status: 301
  get '/youtube', to: redirect('https://www.youtube.com/user/fsektionen'), as: :youtube, status: 301

  get :cookies_information, controller: :static_pages, as: :cookies, path: :cookies
  get :about, controller: :static_pages, path: :om
  get 'foretag/om', controller: :static_pages, action: :company_about, as: :company_about
  get 'foretag/vi-erbjuder', controller: :static_pages, action: :company_offer, as: :company_offer
  get 'robots.:format', controller: :static_pages, action: :robots, as: :robots

  # User-related routes
  devise_for :users, skip: [:sessions, :registrations]
  devise_scope :user do
    get 'avbryt_reg' => 'devise/registrations#cancel', as: :cancel_user_registration
    post 'anvandare/skapa' => 'registrations#create', as: :user_registration
    get 'anvandare/registrera' => 'devise/registrations#new', as: :new_user_registration

    #sessions
    get 'logga_in' => 'devise/sessions#new', as: :new_user_session
    post 'logga_in' => 'devise/sessions#create', as: :user_session
    delete 'logga_ut' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  # Scope to change urls to swedish
  scope path_names: {new: 'ny', edit: 'redigera'} do
    resources :tools, path: :verktyg, only: [:show, :index]

    namespace :admin do
      resources :tools, path: :verktyg do
        resources :tool_rentings, path: :låna, except: [:index, :show]
      end
    end

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

    resources :users, path: :anvandare, only: [:show]

    resources :constants

    namespace :admin do
      resources :categories, path: :kategorier, except: :show
    end

    namespace :admin do
      get :cafe, path: :hilbertcafe, controller: :cafe, action: :index
      get :overview_cafe, controller: :cafe, action: :overview, path: 'hilbertcafe/oversikt'

      resources :cafe_shifts, path: :hilbertcafe, except: :index do
        resources :cafe_workers, path: :jobba, only: [:create, :update, :destroy, :new]
        get :setup, as: :setup, on: :collection
        post :setup_create, on: :collection
      end
    end

    get :ladybug_cafe, controller: :cafe, action: :ladybug, path: 'hilbertcafe/nyckelpiga'
    get :cafe, path: :hilbertcafe, controller: :cafe, action: :index
    get :competition_cafe, controller: :cafe, action: :competition, path: 'hilbertcafe/tavling'

    resources :cafe_shifts, path: :hilbertcafe, only: :show do
      get :feed, on: :collection
      get :new, path: :jobba, controller: :cafe_workers
      resources :cafe_workers, path: :jobba, only: [:create, :update, :destroy]
    end

    namespace :admin do
      resources :rents, path: :bilbokning, except: :edit do
        get :preview, path: :visa, on: :member
      end
    end

    resources :rents, path: :bilbokning do
      collection do
        get :overview, path: :oversikt
        post :check_dates
      end
    end

    namespace :admin do
      resources :notices, path: :notiser, except: :show
      resources :menus, path: :meny, except: :show
      resources :main_menus, path: :huvudmeny, except: :show
    end

    namespace :admin do
      resources :pages, path: :sida, except: :show do
        resources :page_elements, path: :element, except: :show
        delete 'destroy_image/:image_id', on: :member, action: :destroy_image, as: :destroy_image
      end
    end

    resources :pages, path: :sida, only: :show

    # Namespace for Nollning
    namespace :nollning do
      get '', controller: :nollnings, action: :index
      get :matrix, controller: :nollnings, action: :matrix, path: :matris
      post "modal/:date", controller: :nollnings, action: :modal, as: :event
      get "modal/:date", controller: :nollnings, action: :modal, as: :get_event
    end

    namespace :admin do
      resources :introductions, path: :nollning, except: :show
    end

    resources :councils, path: :utskott, only: [:index, :show]

    resources :posts, path: :poster, only: [] do
      patch :display, on: :member, path: :visa
      patch :collapse, on: :collection, path: :dolj
    end

    namespace :admin do
      resources :councils, path: :utskott, except: :show do
        resources :posts, path: :poster, except: :show do
          collection do
            delete 'anvandare/:post_user_id', action: :remove_user, as: :remove_user
            patch :add_user
          end
        end
      end

      resources :posts, path: :poster, only: [] do
        get :show_permissions, path: :rattigheter
      end
    end

    namespace :admin do
      resources :faqs, path: :faq, except: [:show]
    end

    resources :faqs, path: :faq, except: [:show]

    namespace :admin do
      resources :contacts, path: :kontakter, except: :show
    end

    resources :contacts, path: :kontakter, only: [:show, :index] do
      post :mail, on: :member
    end

    resources :calendars, path: :kalender,  only: :index do
      get :export, on: :collection
    end

    resources :events, only: :show, path: :evenemang do
      resources :event_registrations, path: :anmalan, only: [:create, :destroy]
    end

    namespace :admin do
      resources :events, path: :evenemang, except: :show do
        resources :event_registrations, path: :anmalan, only: :index
      end
    end

    namespace :admin do
      resources :work_posts, path: :jobbportal
    end

    resources :work_posts, path: :jobbportal, only: [:index, :show]

    namespace :admin do
      resources :news, path: :nyheter
    end

    resources :news, path: :nyheter, only: [:index, :show]

    resources :documents, path: :dokument, only: [:index, :show]

    namespace :admin do
      resources :documents, path: :dokument, except: :show
    end


    namespace :admin do
      resources :elections, path: :val do
        get :nominations, path: :nomineringar, on: :member
        get :candidates, path: :kandideringar, on: :member
      end
    end

    resources :elections, path: :val, only: :index do
      collection do
        resources :nominations, controller: 'elections/nominations',
                                path: :nominera, only: [:create] do
          get '', action: :new, on: :collection, as: :new
        end
        resources :candidates, controller: 'elections/candidates',
                               path: :kandidera, except: [:show, :update]
        resources :posts, path: :poster, only: :show do
          get :modal, on: :member
        end
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
      resources :permissions, only: :index do
        get '/:post_id', action: :show_post, on: :collection, as: :post
        patch '(/:post_id)', action: :update_post, on: :collection, as: :update
      end

      resources :doors, path: :dorrar, except: :show do
        get :accesses, path: :accesser, on: :member
        get :post, path: '/post/:post_id', on: :collection
      end
    end

    resources :short_links, except: [:show, :update, :edit], path: :snabblankar do
      collection do
        get :go
        get :check
      end
    end
  end

  resources :mail_aliases, only: [:index] do
    collection do
      put :update, path: :update, as: :update
      get :search
    end
  end

  namespace :admin do
    resources :groups, path: :faddergrupper, except: :show do
      resources :group_users, path: :anvandare, only: :index do
        patch :set_fadder, on: :member
        patch :set_not_fadder, on: :member
      end
    end
  end

  resources :groups, path: :faddergrupper, except: [:new, :create, :destroy]

  get 'proposals/form' => 'proposals#form'
  post 'proposals/generate' => 'proposals#generate'

  root 'static_pages#index'

  # Catch-all for short links.
  # This must be at the bottom!
  get '*link' => 'short_links#go'
end
