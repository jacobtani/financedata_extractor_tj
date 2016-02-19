Rails.application.routes.draw do
   root 'items#retrieve_current_data'
   get '/data' => 'items#retrieve_current_data', as: :retrieve_data
   get '/all_history' => 'items#search_all_history', as: :search_all_history
   get 'items/stopcapture' => 'items#stop_capture', as: :stop_capture
   get 'items/startcapture' => 'items#start_capture', as: :start_capture
end
