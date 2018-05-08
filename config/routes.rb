Rails.application.routes.draw do
  namespace :api do
    get '/', to: 'collection#index'
  end
end
