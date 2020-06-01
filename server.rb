require 'sinatra'
require 'yaml'

set :bind, '0.0.0.0'

movies = YAML.load(File.read("movies_list.yml"))

get '/' do
  movies.sample
end