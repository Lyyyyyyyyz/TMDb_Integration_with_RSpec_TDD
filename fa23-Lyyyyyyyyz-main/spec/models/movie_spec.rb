require 'rails_helper'
require 'spec_helper'


describe Movie do
  describe 'searching Tmdb by keyword' do
    it 'calls Faraday gem with CS169 domain' do
      # expect(Faraday).to receive(:get).with('https://cs169.org')
      fake_response = { "results" => [{ "title" => "Inception", "release_date" => "2010-07-16" }] }.to_json

      allow(Faraday).to receive(:get).and_return(double(body: fake_response))

      expect(Faraday).to receive(:get).with("#{Movie::TMDB_BASE_URL}/search/movie", hash_including(query: 'Inception')) 
      
      Movie.find_in_tmdb({title: 'Inception', release_year: 2010, language: 'en'})

      #Movie.find_in_tmdb('https://cs169.org')
    end
    it 'calls Faraday gem with correct parameters' do
      fake_response = { "results" => [{ "title" => "Inception", "release_date" => "2010-07-16" }] }.to_json

      allow(Faraday).to receive(:get).and_return(double(body: fake_response))
      
      expect(Faraday).to receive(:get).with("#{Movie::TMDB_BASE_URL}/search/movie", hash_including(query: 'Inception'))
      Movie.find_in_tmdb({title: 'Inception', release_year: 2010, language: 'en'})
    end
  end
  #changed for part5
  it 'calls Tmdb with valid API key' do
    fake_response = { "results" => [{ "title" => "hacker", "release_date" => "2010-07-16" }] }.to_json
  
    allow(Faraday).to receive(:get).and_return(double(body: fake_response))
    
    expect(Faraday).to receive(:get).with("#{Movie::TMDB_BASE_URL}/search/movie", hash_including(api_key: ENV['TMDB_API_KEY']))
    Movie.find_in_tmdb({title: "hacker", language: "en"})
  end

end