Rails.application.routes.draw do
   root 'items#retrieve_current_data'
   get '/data' => 'items#retrieve_current_data', as: :retrieve_data
   get '/history' => 'items#search_history', as: :search_history
   get '/all_history' => 'items#search_all_history', as: :search_all_history

   get 'items/stopcapture' => 'items#stop_capture', as: :stop_capture
   get 'items/startcapture' => 'items#start_capture', as: :start_capture
   get 'items/generate_pdf_reports' => 'items#generate_pdf_reports', as: :generate_pdf_reports, :defaults => { :format => 'pdf' }

end
