Xtremers::Application.routes.draw do
  match '/rate' => 'rater#create', :as => 'rate'

  resources :products, except: [:index]
  resources :bids, only: [:show, :new, :create]

  get "products/new"   => 'products#new', :as => 'post'

  get "products/create"

  get 'products/review' => 'products#show', :as => 'show'

  get 'products/picture/:id' => 'products#picture', :as => 'picture'

  devise_for :users do get '/users/sign_out' => 'devise/sessions#destroy' end

  root to: 'application#index'

  match '/users' => 'application#index', as: :user_root

  match '/watch_list' => 'users#watch_list', as: :watch_list

  match '/add_to_watch_list' => 'users#add_to_watch_list', as: :add_to_watch_list

  match '/remove_from_watch_list' => 'users#remove_from_watch_list', as: :remove_from_watch_list
  match '/active_products' => 'products#active', as: :user_active_products
  match '/my_bids' => 'users#my_bids', as: :user_my_bids




  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
