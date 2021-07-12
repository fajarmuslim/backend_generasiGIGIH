require 'sinatra'
require 'sinatra/reloader'

get '/hello' do
  'hello world!'
end

get '/messages' do
  "<h1 style='background-color:DodgerBlue;'>Hello world!</h1>"
end

get '/messages/:name' do
  name = params['name']
  color = params['color'] || 'DodgerBlue'
  "<h1 style='background-color:#{color};'>Hello #{name}!</h1>"
end

# they will redirect to '/messages/:name' . the rest of parameter is optional
# http://localhost:4567/messages/fajar?color=green&key=value

# 404 Error!
not_found do
  status 404
  erb :oops
end
