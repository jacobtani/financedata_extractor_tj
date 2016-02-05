Rails.application.routes.draw do
   root 'items#retrieve_current_data'
   get '/data' => 'items#retrieve_current_data', as: :retrieve_data
end
