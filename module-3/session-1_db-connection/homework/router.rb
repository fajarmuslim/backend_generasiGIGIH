require 'sinatra'
require 'sinatra/reloader'
require_relative './db_connector'

get '/' do
  items = get_all_items
  erb :index, locals:{
    items: items
  }
end

get '/items/new' do
  categories = get_all_categories
  erb :create_item, locals:{
    categories: categories
  }
end

post '/items/create' do
  name = params['name']
  price = params['price']
  category_id = params['category_id']

  create_new_item(name, price, category_id)
  redirect '/'
end

get '/items/:id' do
  id = params['id']
  item = get_item_by_id(id)
  erb :show_item, locals: {
    item: item
  }
end

get '/items/edit/:id' do
  id = params['id']
  item = get_item_by_id(id)
  categories = get_all_categories
  erb :edit_item, locals: {
    item: item,
    categories: categories
  }
end

put '/items/edit_item' do
  id = params['id']
  name = params['name']
  price = params['price']
  category_id = params['category_id']

  edit_item(id, name, price, category_id)
  redirect '/'
end

delete '/items/delete/:id' do
  id = params['id']
  delete_item(id)
  redirect "/"
end