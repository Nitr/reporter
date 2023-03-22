Reporter::Engine.routes.draw do
  resources :reports, only: %i[index new create]
end
