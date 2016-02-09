require 'sidekiq/web'

Rails.application.routes.draw do
   mount Sidekiq::Web, at: "/sidekiq"
   root 'items#retrieve_current_data'
   get '/data' => 'items#retrieve_current_data', as: :retrieve_data
   get '/history' => 'items#search_history', as: :search_history
   get 'items/stopcapture' => 'items#stop_capture', as: :stop_capture
   get 'items/startcapture' => 'items#start_capture', as: :start_capture
end
