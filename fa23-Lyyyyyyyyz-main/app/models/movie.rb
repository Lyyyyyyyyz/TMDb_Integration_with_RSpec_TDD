class Movie < ActiveRecord::Base
  TMDB_BASE_URL = "https://api.themoviedb.org/3"
  TMDB_API_KEY = ENV['TMDB_API_KEY']

    def self.all_ratings
      ['G', 'PG', 'PG-13', 'R']
    end
    
    def self.with_ratings(ratings, sort_by)
      if ratings.nil?
        all.order sort_by
      else
        where(rating: ratings.map(&:upcase)).order sort_by
      end
    end
    def self.find_in_tmdb(params)
      terms = params[:title]
      language = params[:language].presence || 'en-US'
      release_year = params[:release_year].presence  # Use presence to ensure nil if empty

      base_url = "https://api.themoviedb.org/3/search/movie"
      query_params = {
        api_key: '14c47f195621386fc5e445cc13efa448',
        query: URI.encode_www_form_component(terms),
        language: language
      }
      query_params[:year] = release_year unless release_year.blank?  # Add year if not blank

  uri = URI(base_url)
  uri.query = URI.encode_www_form(query_params)

  response = Faraday.get(uri)
    
      # Check if the request was successful
      if response.success?
        body = JSON.parse(response.body)
    
        if body["results"]
          results = body["results"]
    
          # Map results to movies array
          movies = results.map do |movie|
            {
              title: movie["title"],
              release_date: movie["release_date"],
              rating: "R" # Placeholder rating
            }
          end
        else
          Rails.logger.warn "No results key found in TMDB response: #{body}"
          movies = []
        end
      else
        Rails.logger.error "TMDB API request failed with status #{response.status}: #{response.body}"
        movies = []
      end
    
      movies
    end
    
    
  end 