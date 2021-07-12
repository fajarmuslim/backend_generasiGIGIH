require 'sinatra'

get '/messages' do
  'Hello world!'
end

# 404 Error!
not_found do
  status 404
  erb :oops
end