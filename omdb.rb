require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'


get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]
  response = Typhoeus.get("www.omdbapi.com", :params => {:s => "#{search_str}"})
  # Make a request to the omdb api here!
  search_str = response.body

  parsed = JSON.parse(search_str)
  
  # results = parsed['Search'].map {|x| "#{x['Title']} - #{x['Year']}"}
  # omdb_id = parsed['Search'].map {|x| "#{x['imdbID']}"}
    # closer = results.each {|x| puts "#{x}"}
  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  
# <a href=\"/results/\"#{x['imdbID']}"</a>

  parsed["Search"].map do |x|
    html_str += "<li><a href=/poster/#{x["imdbID"]}> #{x["Title"]} - #{x["Year"]} </a> </li>"
  end

  html_str += "</ul></body></html>"

end

get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.
  response = Typhoeus.get("www.omdbapi.com", :params => {:i => "#{imdb_id}"})
  # # Make a request to the omdb api here!
  search_str = JSON.parse(response.body)

  # parsed = JSON.parse(search_str)
 
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str += "<h3><img src=#{search_str['Poster']}></h3>"

  html_str += '<br /><a href="/">New Search</a></body></html>'

end

