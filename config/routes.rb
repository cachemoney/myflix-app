Myflix::Application.routes.draw do
  get "videos/index"

  get "videos/show"

  get 'ui(/:action)', controller: 'ui'
end
