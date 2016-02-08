require 'sidekiq/web'

Rails.application.routes.draw do
   mount Sidekiq::Web, at: "/sidekiq"
   root 'items#index'
   get '/data' => 'items#retrieve_current_data', as: :retrieve_data
   get '/history' => 'items#search_history', as: :search_history

end
