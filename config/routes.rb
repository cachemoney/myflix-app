Myflix::Application.routes.draw do

	resources :videos
	match "/home"	=> "videos#index", as: "home"
  get 'ui(/:action)', controller: 'ui'
end
