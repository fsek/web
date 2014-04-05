Fsek::Application.routes.draw do

  # Resources on the page
  resources :news
  match 'nyheter' => 'news#nyheter', via: :get
  match 'nyheter/ny' => 'news#new', via: :get
  match 'nyheter/ny' => 'news#new', via: :post
  match 'nyheter/:id' => 'news#show',via: :get
  
  
  get 'kalender' => 'static_pages#kalender'
  get 'kurslankar' => 'static_pages#kurslankar'
  get 'styrelse' => 'static_pages#styrelse'
  get 'utskott' => 'static_pages#utskott'
  get 'utskott/cafemasteri' => 'static_pages#cafe', as: :cafe 
  get 'utskott/fos' => 'static_pages#fos', as: :fos
  get 'utskott/kulturministerie' => 'static_pages#kulturministerie', as: :km
  get 'utskott/naringslivsutskott' => 'static_pages#naringslivsutskott', as: :fnu
  get 'utskott/prylmasteri' => 'static_pages#prylmasteri', as: :pryl
  get 'utskott/sanningsministerie' => 'static_pages#sanningsministerie', as: :sanning  
  get 'utskott/sexmasteri' => 'static_pages#sexmasteri', as: :sexmasteri
  get 'utskott/studieradet' => 'static_pages#studierad', as: :studierad
  get 'start' => 'start_page#startsida'
  get 'libo' => 'static_pages#libo'  
  get 'kontakt' => 'static_pages#kontakt'
  # User-related routes
  devise_for :users, skip: [:sessions, :registrations], controllers: {registrations: "registrations"}
  devise_scope :user do
    #registration
    get     'avbryt_reg'  => 'registrations#cancel', as: :cancel_user_registration
    post    'registrera'        => 'registrations#create', as: :user_registration 
    get     'registrera'     => 'registrations#new',    as: :new_user_registration 
    get     'anvandare/redigera'   => 'registrations#edit',   as: :edit_user_registration 
    patch   'user'        => 'registrations#update'
    put     'user'        => 'registrations#update'
    delete  'user'        => 'registrations#destroy'

    #sessions
    get     'logga_in'       => 'devise/sessions#new',         as: :new_user_session
    post    'logga_in'       => 'devise/sessions#create',      as: :user_session
    delete  'logga_ut'      => 'devise/sessions#destroy',     as: :destroy_user_session
  end
  get 'anvandare' => 'users#index', as: :users
  resources :profiles, only: [:show, :edit, :update]


   
  # Homepage of the system!
  # Will most likely be a controller showing a welcome screen?
  root 'start_page#startsida'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
