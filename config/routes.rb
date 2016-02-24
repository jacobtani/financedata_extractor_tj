Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }
  root 'stock_records#retrieve_current_data'
  get '/' => 'stock_records#retrieve_current_data', as: :retrieve_current_data
  get '/history' => 'stock_records#retrieve_historic_data', as: :retrieve_historic_data
  get 'stock_records/stopcapture' => 'stock_records#stop_capture', as: :stop_capture
  get 'stock_records/startcapture' => 'stock_records#start_capture', as: :start_capture
  resources :subscriptions
end
