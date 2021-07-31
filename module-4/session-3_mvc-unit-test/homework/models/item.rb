require_relative 'category'

class Item
  attr_accessor :id, :name, :price, :categories

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @price = params[:price]
    @categories = []
  end

  def self.save_category_items(category_id, item_ids)
    client = create_db_client

    item_ids.each do |item_id|
      client.query("INSERT INTO item_categories (item_id, category_id) VALUES (#{item_id}, #{category_id})")
    end
  end

  def save
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO items(name, price) VALUES ('#{name}', #{price})")
  end

  def self.find_item_with_categories(item_id)
    client = create_db_client
    result = client.query("SELECT * FROM items WHERE id = #{item_id}")
    item = convert_sql_result_to_array(result)[0]
    item.categories = Category.find_categories_by_item_id(item_id)

    item
  end

  def self.find_all
    client = create_db_client
    result = client.query('SELECT * FROM items')
    convert_sql_result_to_array(result)
  end

  def self.find_item_by_id(id)
    client = create_db_client
    result = client.query("SELECT * FROM items WHERE id = #{id}")
    convert_sql_result_to_array(result)[0]
  end

  def self.find_items_by_category_id(category_id)
    client = create_db_client
    result = client.query("SELECT * FROM item_categories WHERE category_id = #{category_id}")
    items = []
    result.each do |row|
      items << find_item_by_id(row['item_id'])
    end

    items
  end

  def self.find_id_with_name_and_price(name, price)
    client = create_db_client
    result = client.query("SELECT id FROM items WHERE name = '#{name}' AND price = #{price}")
    convert_sql_result_to_array(result)[0].id
  end

  def self.convert_sql_result_to_array(result)
    items = []
    result.each do |row|
      item = Item.new(
        id: row['id'],
        name: row['name'],
        price: row['price'],
        categories: []
      )
      items << item
    end
    items
  end

  def self.update_item(params)
    client = create_db_client
    client.query("UPDATE items SET name = '#{params['name']}', price = #{params['price']} WHERE id = #{params['id']}")
  end

  def valid?
    return false if name.nil? || price.nil?

    true
  end

  def self.delete_item(id)
    client = create_db_client
    client.query("DELETE FROM item_categories WHERE item_id = #{id}")
    client.query("DELETE FROM items WHERE id = #{id}")
  end

  def self.delete_item_categories_item_ids(category_id, item_ids)
    client = create_db_client

    item_ids.each do |item_id|
      client.query("DELETE FROM item_categories WHERE item_id = #{item_id} AND category_id = #{category_id}")
    end
  end

  def self.save_item_categories_item_ids(category_id, item_ids)
    client = create_db_client

    item_ids.each do |item_id|
      client.query("INSERT INTO item_categories (item_id, category_id) VALUES (#{item_id}, #{category_id})")
    end
  end
end
