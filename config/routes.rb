Rails.application.routes.draw do

  get 'announcements/new'
  get 'announcements/index'

  # The root page of the application
  root 'static_pages#home'

  # URLs for the rest of the static pages
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'unauthorized' => 'static_pages#unauthorized'
  get 'norooms' => 'static_pages#no_rooms'

  get 'signup' => 'users#newstudent'
  get 'history' => "users#history"
  get 'instructorsignup' => 'users#newinstructor'
  get 'adminsignup' => 'users#newadmin'
  
  get 'login' => 'user_session#new'
  post 'login' => 'user_session#create'
  delete 'logout' => 'user_session#destroy'
  
  get 'room_history_display' =>'student_rooms#room_history_display'
  get 'get_student_history' =>'student_rooms#get_student_history'
  get 'reservedshow'=>'student_rooms#enrolledshow'
  delete 'reservedshow'=>'student_rooms#enrolledshow'
  get 'pendingshow'=>'student_rooms#pendingshow'
  put 'complete'=> 'student_rooms#complete'
  get 'student_room_index'=> 'student_rooms#index'
  get 'roomsall'=>'rooms#index'
  get 'roomcreate'=>'rooms#new'
  patch 'roomedit'=>'rooms#edit'
  get 'rooms/enroll/:id' => 'rooms#enroll'
  get 'roomhistorydisplayinstructor'=>'rooms#roomhistorydisplayinstructor'
  get 'get_instructor_history'=>'rooms#get_instructor_history'

  resources :users
  resources :rooms
  resources :student_rooms
  resources :announcements


  resources :conversations do
    resources :messages
  end
  resources :messages



  # This is easy, but for security reasons, dont use this
  # match ':controller(/:action(/:id))', :via => :get

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
