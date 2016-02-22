Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }
  root 'items#retrieve_current_data'
  get '/' => 'items#retrieve_current_data', as: :retrieve_current_data
  get '/history' => 'items#retrieve_historic_data', as: :retrieve_historic_data
  get 'items/stopcapture' => 'items#stop_capture', as: :stop_capture
  get 'items/startcapture' => 'items#start_capture', as: :start_capture
  resources :subscriptions

end
