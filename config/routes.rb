Movies::Application.routes.draw do
  devise_for :users
  resources :movies do
    get 'toggle_watch', :on => :member
    get 'toggle_want', :on => :member    
    get 'toggle_tag', :on => :member
    get 'toggle_rob', :on => :member
    get 'toggle_marina', :on => :member
    get 'all', :on => :collection
    get 'tagged', :on => :collection
    get 'unwatched', :on => :collection    
    get 'watched', :on => :collection
    get 'wanted', :on => :collection
    get 'recent_watched', :on => :collection
    get 'recent_added', :on => :collection    
    get 'rob', :on => :collection
    get 'marina', :on => :collection
    get 'id_list', :on => :collection
    get 'user_queue', :on => :collection
    get 'set_user_queue', :on => :collection
    get 'search', :on => :collection
  end
  
  root to: 'movies#index'
  
  #resources :movies

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
