Fsek::Application.routes.draw do


  resources :constants

  post "githook" => "githook#index"
  get "githook/dev" => "githook#dev"
  get "githook/master" => "githook#master"

  # Resources on the page
  #get 'kurslankar' => 'static_pages#kurslankar'
  get 'libo' => 'static_pages#libo', as: :libo
  get 'kalender' => 'events#calendar', as: :kalender
  get '/nollning', to: redirect('http://nollning.fsektionen.se'), as: :nollning
  get '/vecktorn', to: redirect('http://old.fsektionen.se/vecktorn/signup.php'), as: :vecktorn_signup

  get 'om' => 'static_pages#om', as: :om

  get 'engagemang' => 'static_pages#utskott', as: :engagemang
  #get 'multimedia' => 'static_pages#lankar', as: :multimedia #Ev. efterfrågad av vårt kära Sanningsministerium!
  #get 'lankar' => 'static_pages#lankar', as: :lankar

  get 'organisation' => 'static_pages#utskott', as: :organisation
  #get 'erbjudande' => 'static_pages#om', as: :erbjudande

  # User-related routes
  devise_for :users, skip: [:sessions, :registrations], controllers: {registrations: "registrations"}
  devise_scope :user do
    #registration
    get 'avbryt_reg' => 'registrations#cancel', as: :cancel_user_registration
    post 'anvandare/skapa' => 'registrations#create', as: :user_registration
    get 'anvandare/registrera' => 'registrations#new', as: :new_user_registration
    patch 'anvandare/redigera/:id' => 'users#update_password', as: :update_user_registration
    get 'anvandare/redigera' => 'registrations#edit', as: :edit_user_registration
    delete 'anvandare/ta_bort/:id' => 'users#destroy', :as => :admin_destroy_user

    #sessions
    get 'logga_in' => 'devise/sessions#new', as: :new_user_session
    post 'logga_in' => 'devise/sessions#create', as: :user_session
    delete 'logga_ut' => 'devise/sessions#destroy', as: :destroy_user_session
    patch 'anvandare/redigera' => 'users#change_role', as: :change_role
  end

  get 'anvandare' => 'users#index', as: :users

  # Scope to change urls to swedish
  scope path_names: { new: 'ny', edit: 'redigera' } do

    resources :notices

    # A scope to put car-associated things under /bil
    # /d.wessman
    scope :bil do
      namespace :admin do
        resources :rents, path: :bokningar, except: [:index, :edit] do
          get :preview, path: :visa, on: :member
        end
        get '', controller: :rents, action: :main, as: :car
      end
      resources :rents, path: :bokningar do
        patch :authorize, on: :member, path: :auktorisera
      end
      get '', controller: :rents, action: :main, as: :bil
    end

    resources :notices, path: :notiser do
      post :display, path: :visa, on: :member
      get :image, path: :bild, on: :member
    end
    resources :menus, path: :meny, except: :show

    resources :posts, path: :poster, only: :index

    resources :councils, path: :utskott do
      resources :posts, path: :poster do
        patch :remove_profile, on: :member
        patch :add_profile_username, on: :member
      end
      resource :page, path: :sida do
        resources :page_elements, path: :element, on: :member
      end
    end

    resources :faqs, path: :faq

    resources :contacts, path: :kontakt do
      post :mail, on: :member
    end

    resources :profiles, path: :profil do
      patch :remove_post, on: :member
      get :avatar, on: :member
    end

    resources :events do
      get :export, on: :collection
    end

    resources :work_posts, path: :jobbportal, except: :show

    resources :news, path: :nyheter

    resources :documents, path: :dokument


    namespace :admin do
      resources :elections, path: :val do
        get :nominations, path: :nomineringar, on: :member
        get :candidates, path: :kandideringar, on: :member
      end
    end
    resources :elections, path: :val, only: :index
    namespace :election, path: :val do
      resources :nominations, path: :nominera, only: [:create] do
        get '', action: :new, on: :collection, as: :new
      end
      resources :candidates, path: :kandidera, except: [:edit]

    end

    resources :albums, path: :galleri do
      post :edit, on: :member
      get :settings, path: :installningar, on: :collection
      get :upload_images, path: :ladda_upp, on: :member
      patch :upload_images, path: :ladda_upp, on: :member
      delete :destroy_images, path: :ta_bort_bilder, on: :member
      post :settings, path: :installningar, on: :collection
      post '', on: :member, action: :show
      resources :images, path: :bilder, except: [:new]
    end
  end
  post '' => 'albums#index', as: :index_albums

  concern :the_role, TheRole::AdminRoutes.new

  namespace :admin do
    concerns :the_role
  end

  resources :short_links, :except => [ :show, :update, :edit ] do
    collection do
      get 'go' => 'short_links#go'
      get 'check' => 'short_links#check'
    end
  end

  root 'static_pages#index'

  # Catch-all for short links.
  # This must be at the bottom!
  get '*link' => 'short_links#go'
end
