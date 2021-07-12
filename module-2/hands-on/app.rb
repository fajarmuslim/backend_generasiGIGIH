require 'sinatra'
require 'sinatra/reloader'

items_arr = [1,3,3]
get '/hello' do
  'hello world!'
end

# get '/messages' do
#   "<h1 style='background-color:DodgerBlue;'>Hello world!</h1>"
# end

get '/messages' do
  erb :message, locals: {
    color: 'DodgerBlue',
    name: 'fajar'
  }
end

# get '/messages/:name' do
#   name = params['name']
#   color = params['color'] || 'DodgerBlue'
#   "<h1 style='background-color:#{color};'>Hello #{name}!</h1>"
# end
#
get '/messages/:name' do
  erb :message, locals: {
    color: params['color'] || 'DodgerBlue',
    name: params['name']
  }
end

# they will redirect to '/messages/:name' . the rest of parameter is optional
# http://localhost:4567/messages/fajar?color=green&key=value

get '/login' do
  erb :login
end

post '/login' do
  if params['username'] == 'admin' && params['password'] == 'admin'
    return 'success logged in!'
  else
    redirect '/login'
  end
end

get '/list' do
  erb :list, locals: {
    items: items_arr
  }
end

get '/list_form' do
  erb :list_form, locals: {
    items: items_arr
  }
end

post '/list_form' do
  items_arr << params['item']
  redirect '/list_form'
end

# 404 Error!
not_found do
  status 404
  erb :oops
end
