class MoviesController < ApplicationController
    before_action :force_index_redirect, only: [:index]
  
    
    
    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
    end
  
    def index
      @all_ratings = Movie.all_ratings
      @movies = Movie.with_ratings(ratings_list, sort_by)
      @ratings_to_show_hash = ratings_hash
      @sort_by = sort_by
      # remember the correct settings for next time
      session['ratings'] = ratings_list
      session['sort_by'] = @sort_by
    end
    
  
    def search_tmdb
      @movies = []

  # If the request is a GET request render the page without any further logic
  if request.get?
    # Check if there are previously input movie details in the flash
    if flash[:movie_details]
      @movie_details = flash[:movie_details]
      flash.now[:alert] = flash[:errors].join(", ")
    end
    render 'search_tmdb' and return
  end
      
      # If the title is blank, flash an error and stay on the search page
      if params[:title].blank?        
        #flash.now[:notice] = "Please fill in all required fields!"
        #render 'search_tmdb' and return
               
        flash.now[:alert] = "Title cannot be blank!"
        render 'search_tmdb' and return
      
      end
      
      # Fetch movies from TMDB
      @movies = Movie.find_in_tmdb(params)
      
      # If no movies are found, flash an error and stay on the search page
      if @movies.empty?
        flash.now[:notice] = "No movies found with given parameters!"
        render 'search_tmdb' and return
      end
    end
    
    
  
    def new
      # default: render 'new' template
    end
  
    
    def create
      @movie = Movie.create(movie_params)
    
      if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to search_path
      else
        # If the save was not successful, handle the error
        # If this is from TMDB search, you may want to redirect back to search_tmdb_path
        # and include the movie details in the flash to repopulate the form.
        flash.now[:alert] = @movie.errors.full_messages.join(", ")
        
        # Determine where the request came from and set the appropriate redirect
       # if params[:from_tmdb]
          redirect_to search_path
       # else
         # render 'new' 
       # end
      end
    end
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
    
    private
    

    def movie_params
      params.require(:movie).permit(:title, :rating, :release_date)
    end
    def force_index_redirect
      if !params.key?(:ratings) || !params.key?(:sort_by)
        flash.keep
        url = movies_path(sort_by: sort_by, ratings: ratings_hash)
        redirect_to url
      end
    end
  
    def ratings_list
      params[:ratings]&.keys || session[:ratings] || Movie.all_ratings
    end
  
    def ratings_hash
      Hash[ratings_list.collect { |item| [item, "1"] }]
    end
  
    def sort_by
      params[:sort_by] || session[:sort_by] || 'id'
    end
  end
  