require 'rest-client'
require 'json'
require 'pry'

def get_json_info (hash_url)
  # gets Ruby legible Json info
  url_info = RestClient.get(hash_url)
  JSON.parse(url_info)
end


def right_character?(character)
  character_hash = get_json_info("http://www.swapi.co/api/people/")

  specific_character_data = {}

  character_hash["results"].each do |character_data|
    specific_character_data = character_data if character_data["name"].downcase == character
  end
  specific_character_data
end


def right_movie?(movie)
  movie_hash = get_json_info("http://www.swapi.co/api/films/")

  specific_movie_data = {}

  movie_hash["results"].each do |movie_data|

    movie_data.keys.each do |data_key|
      specific_movie_data = movie_data if movie_data[data_key].to_s.downcase.include?(movie.downcase)
    end

    if movie_data["episode_id"].to_s == movie
      specific_movie_data = movie_data
      break
    end

  end
  specific_movie_data
end


def parse_movie_data(movie_hash)
  movie_hash.each do |keys, values|
    if "characters" == keys
      break
    else
      puts "#{keys}: '#{values}'"
      puts "\n"
    end
  end
end


def get_character_movies_from_api(character)
  character_data = right_character?(character)

  movies_array = []

  character_data["films"].each do |movie_url|
    movie_hash = get_json_info(movie_url)
    movies_array << movie_hash
  end
  movies_array
end


def parse_character_movies(films_hash)
  films_hash.each do |film_data|
    film_data.each do |keys, values|
      if "characters" == keys
        puts "------------------"
        break
      else
        puts "#{keys}: '#{values}'"
        puts "\n"
      end
    end
  end
end


def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end


def show_movie_info(movie)
  film = right_movie?(movie)
  parse_movie_data(film)
end


def show_info(input)
  if right_character?(input) == {}
    show_movie_info(input)
  else
    show_character_movies(input)
  end
end
