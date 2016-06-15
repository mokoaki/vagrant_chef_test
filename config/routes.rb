Rails.application.routes.draw do
  root 'welcome#index'

  get '/mail', to: 'welcome#mail'
end
