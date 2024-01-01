Rottenpotatoes::Application.routes.draw do
    resources :movies 
    # map '/' to be a redirect to '/movies'
    root :to => redirect('/movies')
    #get 'search' => 'movies#search_tmdb'
    #post 'search', to: 'movies#search_tmdb'
  
    post 'add_movie', to: 'movies#add_movie', as: :add_movie
    match 'search', to: 'movies#search_tmdb', via: [:get, :post]


    post 'add_movie', to: 'movies#add_movie'
    

end 
  