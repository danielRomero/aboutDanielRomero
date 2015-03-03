Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'application#index'
  scope "(:locale)", locale: /en|es/ do
    get '/', to: 'application#index'
    get 'contact', to: 'application#contact'
    get '/tweets/:page', to: 'tweets#index', as: 'tweets'
  end
  get 'authenticate_twitter', to: 'twitter#authenticate'
  get 'authenticate_google', to: 'google#authenticate'
  get 'authenticate_github', to: 'github#authenticate'
  post 'authenticate_facebook', to: 'facebook#authenticate'

  get '/sitemap', to: 'application#sitemap', as: 'sitemap', defaults: { format: 'xml' }
end
