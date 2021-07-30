require 'sinatra'
require 'sinatra/reloader'
require_relative 'db/mysql_connector'
require_relative 'controllers/root_controller'
require_relative 'controllers/item_controller'
require_relative 'controllers/category_controller'
require_relative 'controllers/customer_controller'
require_relative 'controllers/order_controller'

get '/' do
  root_controller = RootController.new
  root_controller.show_pages
end

# ITEM
get '/item' do
  item_controller = ItemController.new
  item_controller.show_all
end

get '/item/:id' do
  item_controller = ItemController.new
  item_controller.show_item(params['id'])
end

get '/create_item' do
  item_controller = ItemController.new
  item_controller.create_item_form
end

post '/item' do
  item_controller = ItemController.new
  item_controller.create_item(params)
  redirect '/item'
end

delete '/item/:id' do
  ItemController.delete_item(params['id'])
  redirect '/item'
end

get '/edit_item/:id' do
  item_controller = ItemController.new
  item_controller.item_edit_form(params['id'])
end

put '/item/:id' do
  ItemController.edit_item(params)
  redirect '/item'
end

# CATEGORY
get '/category' do
  category_controller = CategoryController.new
  category_controller.show_all
end

get '/category/:id' do
  category_controller = CategoryController.new
  category_controller.show_category(params['id'])
end

get '/create_category' do
  category_controller = CategoryController.new
  category_controller.create_category_form
end

post '/category' do
  category_controller = CategoryController.new
  category_controller.create_category(params)
  redirect '/category'
end

delete '/category/:id' do
  CategoryController.delete_category(params['id'])
  redirect '/category'
end

get '/edit_category/:id' do
  category_controller = CategoryController.new
  category_controller.category_edit_form(params['id'])
end

put '/category/:id' do
  CategoryController.edit_item(params)
  redirect '/category'
end

# CUSTOMER
get '/customer' do
  customer_controller = CustomerController.new
  customer_controller.show_all
end

get '/customer/:id' do
  customer_controller = CustomerController.new
  customer_controller.show_customer(params['id'])
end

get '/create_customer' do
  customer_controller = CustomerController.new
  customer_controller.create_customer_form
end

post '/customer' do
  customer_controller = CustomerController.new
  customer_controller.create_customer(params)
  redirect '/customer'
end

delete '/customer/:id' do
  CustomerController.delete_customer(params['id'])
  redirect '/customer'
end

get '/edit_customer/:id' do
  customer_controller = CustomerController.new
  customer_controller.customer_edit_form(params['id'])
end

put '/customer/:id' do
  CustomerController.edit_customer(params)
  redirect '/customer'
end

# ORDER
get '/order' do
  order_controller = OrderController.new
  order_controller.show_all
end

get '/order/:id' do
  order_controller = OrderController.new
  order_controller.show_order(params['id'])
end

get '/create_order' do
  order_controller = OrderController.new
  order_controller.create_order_form
end

post '/order' do
  OrderController.create_order(params)
  redirect '/order'
end

delete '/order/:id' do
  OrderController.delete_order(params['id'])
  redirect '/order'
end

get '/edit_order/:id' do
  order_controller = OrderController.new
  order_controller.order_edit_form(params['id'])
end

put '/order/:id' do
  OrderController.edit_order(params)
  redirect '/order'
end
