Rails.application.routes.draw do
  resources :responders, param: :name, defaults: { format: :json }, except: [:new, :edit, :delete]
  resources :emergencies, param: :code, defaults: { format: :json }, except: [:new, :edit, :delete]

  match '*path' => 'application#page_not_found', via: [:get, :post]
end
