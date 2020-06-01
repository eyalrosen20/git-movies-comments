require 'dotenv/load'
require 'awesome_print'
require 'json'
require 'hpath'
require 'httparty'
require 'yaml'

loves = YAML.load(File.read("loves.yml"))

results = []

loves.keys.each do |key|

  person = loves[key]

  url = "https://api.themoviedb.org/3/discover/movie"

  params = {
      api_key: ENV['TMDB_KEY'],
      sort_by: 'popularity.desc'
  }
  params[person['field']] = person['value']

  puts "Adding movies of ❤️  #{key}  ❤️"

  res = HTTParty.get(url, query: params)
  movies_res = res.parsed_response
  titles = Hpath.get(movies_res, "results/title")
  dates = Hpath.get(movies_res, "results/release_date")
  years = dates.map { |date| date.match(/(\d+)/)[0] }

  list = []
  titles.each_with_index do |title, index|
    list << "#{title} (#{years[index]})"
  end

  results.concat(list)

end

results.uniq!

File.write("movies_list.yml", results.to_yaml)