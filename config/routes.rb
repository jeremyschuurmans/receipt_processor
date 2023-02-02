Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post "/receipts/process", to: "receipts#create" # The create action cannot be renamed in Rails, so mapping /receipts/process to receipts#create
  get "/receipts/:id/points", to: "receipts#points"
end
