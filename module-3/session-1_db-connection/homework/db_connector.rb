require 'mysql2'
require_relative 'Item'
require_relative 'Category'

def create_db_client
  Mysql2::Client.new(
    host: 'localhost',
    username: 'root',
    password: 'generasiGIGIH100%',
    database: 'food_oms_db'
  )
end

def get_all_items
  client = create_db_client
  raw_data = client.query('select * from items')
  items = []

  raw_data.each do |data|
    item = Item.new(data['name'], data['price'], data['id'])
    items.push(item)
  end

  items
end

def get_all_categories
  client = create_db_client
  raw_data = client.query('select * from categories')
  categories = []

  raw_data.each do |data|
    category = Category.new(data['id'],data['name'])
    categories.push(category)
  end

  categories
end

def get_items_alongside_categories
  client = create_db_client
  raw_data = client.query("select items.id as 'id', items.price as 'price', items.name as 'name', categories.name as 'category_name', categories.id as 'category_id' from items join item_categories on item_categories.item_id = items.id join categories on item_categories.category_id= categories.id")
  items = []

  raw_data.each do |data|
    category = Category.new(data['category_id'], data['category_name'])
    item = Item.new(data['name'], data['price'], data['id'], category)
    items.push(item)
  end

  items
end

def get_items_below_price (price)
  client = create_db_client
  client.query("select * from items where price < #{price}")
end

def create_new_item(name, price, category_id)
  client = create_db_client
  client.query("insert into items(name, price) values ('#{name}', #{price})")
  item_id = get_item_id(name, price)

  client.query("insert into item_categories(item_id, category_id) values ('#{item_id}', '#{category_id}')")
end

def get_item_id(name, price)
  client = create_db_client
  id = client.query("select id from items where name = '#{name}' and price = #{price}")
  id.first['id']
end

def get_item_by_id(id)
  client = create_db_client
  raw_data = client.query("select items.id as 'id', items.name as 'name', items.price as 'price', categories.id as 'category_id', categories.name as 'category_name' from items join item_categories on items.id = item_categories.item_id join categories on item_categories.category_id = categories.id where items.id = #{id}")
  category = Category.new(raw_data.first['category_id'], raw_data.first['category_name'])
  Item.new(raw_data.first['name'], raw_data.first['price'], raw_data.first['id'], category)
end

def delete_item(id)
  client = create_db_client
  client.query("delete FROM items WHERE id = #{id}")
end

def edit_item(id, name, price, category_id)
  client = create_db_client
  client.query("update items SET name = '#{name}', price = #{price} WHERE id = #{id}")
  client.query("UPDATE item_categories SET category_id = #{category_id} WHERE item_id = #{id}")
end
