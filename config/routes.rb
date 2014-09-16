
Fsek::Application.routes.draw do
    
  # Resources on the page
  
  get 'cafebokning' => 'calendar#cafebokning'
  get 'kalender/export' => 'calendar#export.ics', as: :subscription
  get 'kurslankar' => 'static_pages#kurslankar'
  get 'styrelse' => 'static_pages#styrelse', as: :styrelse
  get 'utskott' => 'static_pages#utskott', as: :utskott
  get 'oldutskott/cafemasteri' => 'static_pages#cafe', as: :cafe 
  get 'oldutskott/fos' => 'static_pages#fos', as: :fos
  get 'oldutskott/kulturministerie' => 'static_pages#kulturministerie', as: :km
  get 'oldutskott/naringslivsutskott' => 'static_pages#naringslivsutskott', as: :fnu
  get 'oldutskott/prylmasteri' => 'static_pages#prylmasteri', as: :pryl
  get 'oldutskott/sanningsministerie' => 'static_pages#sanningsministerie', as: :sanning  
  get 'oldutskott/sexmasteri' => 'static_pages#sexmasteri', as: :sexmasteri
  get 'oldutskott/studieradet' => 'static_pages#studierad', as: :studierad  
  get 'libo' => 'static_pages#libo', as: :libo   
  get 'admin/kontakt' => 'admin#kontakt', as: :admin_kontakt
  post 'admin/kontakt'=> 'admin#kontakt', as: :admin_kontakt_path
  get 'admin/bildgalleri' => 'admin#bildgalleri', as: :admin_bildgalleri
  post 'admin/bildgalleri'=> 'admin#bildgalleri', as: :admin_bildgalleri_path
  get 'admin/utskott' => 'admin#utskott', as: :admin_utskott
  post 'admin/utskott'=> 'admin#utskott', as: :admin_utskott_path
  get 'kalender' => 'calendar#index',as: :kalender
  get '/nollning', to: redirect('http://nollning.fsektionen.se'), as: :nollning
  get '/vecktorn', to: redirect('http://old.fsektionen.se/vecktorn/signup.php'), as: :vecktorn_signup
  
  get 'om' => 'static_pages#om', as: :om
  get 'faq' => 'static_pages#faq', as: :faq
  get 'dokument' => 'static_pages#dokument', as: :dokument
  
  get 'engagemang' => 'static_pages#utskott', as: :engagemang
  get 'multimedia' => 'static_pages#lankar', as: :multimedia #Ev. efterfrågad av vårt kära Sanningsministerium!
  get 'lankar' => 'static_pages#lankar', as: :lankar
  
  get 'organisation' => 'static_pages#utskott', as: :organisation
  get 'erbjudande' => 'static_pages#om', as: :erbjudande
  
  # User-related routes
  devise_for :users, skip: [:sessions, :registrations], controllers: {registrations: "registrations"}
  devise_scope :user do
    #registration
    get     'avbryt_reg'  => 'registrations#cancel', as: :cancel_user_registration
    post    'anvandare/skapa'        => 'registrations#create', as: :user_registration 
    get     'anvandare/registrera'     => 'registrations#new',    as: :new_user_registration
    patch   'anvandare/redigera/:id'        => 'users#update_password', as: :update_user_registration 
    get     'anvandare/redigera'   => 'registrations#edit',   as: :edit_user_registration
    delete  'anvandare/ta_bort/:id' => 'users#destroy', :as => :admin_destroy_user

    #sessions
    get     'logga_in'       => 'devise/sessions#new',         as: :new_user_session
    post    'logga_in'       => 'devise/sessions#create',      as: :user_session   
    delete  'logga_ut'      => 'devise/sessions#destroy',     as: :destroy_user_session
    patch   'anvandare/redigera' => 'users#change_role',  as: :change_role
  end
  
  get 'anvandare' => 'users#index', as: :users
  
  scope path_names: { new: 'ny',edit: 'redigera' } do
    resources :councils, path: :utskott, except: :index do
      resources :posts, path: :poster do
        patch :remove_profile, on: :member
        patch :add_profile_username, on: :member
      end
      resource :page, path: :sida do
        resources :page_elements, path: :element, on: :member
      end
    end
    resources :contacts, path: :kontakt do
      member do
        post :mail
      end
    end    
    resources :profiles, path: :profil do
      patch :remove_post, on: :member
    end
    resources :events  
    resources :news ,path:  :nyhet  
        
    
    resources :albums, path: :galleri do
      get :settings, path: :installningar, on: :collection
      post :settings, path: :installningar, on: :collection      
      post  '', on: :member, action: :show           
      resources :images, path: :bilder do
        get :redigera_godtyckligt, on: :collection, action: :edit_multiple, as: :edit_multiple
        post :edit_multiple, on: :collection
        put :update_multiple, on: :collection
      end                  
    end
  end
  post '' => 'albums#index', as: :index_albums
  
  concern :the_role, TheRole::AdminRoutes.new
  
  namespace :admin do
    concerns :the_role
  end

 
   
  root 'static_pages#index'


end
