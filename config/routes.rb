Fsek::Application.routes.draw do
  
  # Resources on the page
  get 'cafebokning' => 'calendar#cafebokning'
  get 'kalender/export' => 'calendar#export.ics', as: :subscription
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
  post 'kontakt' => 'static_pages#kontakt'
  
  
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
  
  resources :profiles, path: :profil do
    patch :remove_post, on: :member
  end
  resources :events  
  resources :news    ,path:  :nyhet
  resources :calendar , path:  :kalender
  resources :posts, path: :poster do
  patch :remove_profile, on: :member
  patch :add_profile_username, on: :member
  end
  
  resources :albums, path: :galleri do
    
    resources :images, path: :bilder    
  end     
 
   
  root 'start_page#startsida'


end
