require 'mysql2'
require_relative 'Item'
require_relative 'Category'

def create_db_client
  client = Mysql2::Client.new(
    :host => "localhost",
    :username => "root",
    :password => "generasiGIGIH100%",
    :database => "food_oms_db",
  )

  client
end

def get_all_items
  client = create_db_client
  rawData = client.query("select * from items")
  items = Array.new

  rawData.each do |data|
    item = Item.new(data['name'], data['price'], data['id'])
    items.push(item)
  end

  return items
end

def get_all_categories
  client = create_db_client
  categories = client.query("select * from categories")
  return categories
end

def get_items_alongside_categories
  client = create_db_client
  rawData = client.query("select items.id as 'id', items.price as 'price', items.name as 'name', categories.name as 'category_name', categories.id as 'category_id' from items join item_categories on item_categories.item_id = items.id join categories on item_categories.category_id= categories.id")
  items = Array.new

  rawData.each do |data|
    category = Category.new(data['category_id'], data['category_name'])
    item = Item.new(data['name'], data['price'], data['id'], category)
    items.push(item)
  end

  items
end

def get_items_below_price (price)
  client = create_db_client
  items = client.query("select * from items where price < #{price}")
  return items
end

def create_new_item(name, price)
  client = create_db_client
  client.query("insert into items(name, price) values ('#{name}', #{price})")
end


# item_below_price = get_items_below_price(30000)
# puts(item_below_price.each)

# items = get_all_items
# puts(items.each)

# items.each do |item|
#   puts(item.name)
# end

# categories = get_all_categories
# puts(categories.each)
#
# items_and_categories = get_items_alongside_categories
#
# items_and_categories.each do |item|
#   puts(item.name)
# end