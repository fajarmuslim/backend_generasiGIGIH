require_relative '../db/mysql_connector'

class Category
  attr_accessor :id, :name, :items

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @items = []
  end

  def self.save_item_categories_category_ids(item_id, category_ids)
    client = create_db_client

    category_ids.each do |category_id|
      client.query("INSERT INTO item_categories (item_id, category_id) VALUES (#{item_id}, #{category_id})")
    end
  end

  def save
    puts "ini: #{valid?}"
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO categories(name) VALUES ('#{name}')")
  end

  def self.delete_category(id)
    client = create_db_client
    client.query("DELETE FROM item_categories WHERE category_id = #{id}")
    client.query("DELETE FROM categories WHERE id = #{id}")
  end

  def self.delete_item_categories_category_ids(item_id, category_ids)
    client = create_db_client

    category_ids.each do |category_id|
      client.query("DELETE FROM item_categories WHERE item_id = #{item_id} AND category_id = #{category_id}")
    end
  end

  def self.find_categories_by_item_id(item_id)
    client = create_db_client
    result = client.query("SELECT * FROM item_categories WHERE item_id = #{item_id}")
    categories = []
    result.each do |row|
      categories << find_category_by_id(row['category_id'])
    end

    categories
  end

  def self.find_id_with_name(name)
    client = create_db_client
    result = client.query("SELECT id FROM categories WHERE name = '#{name}'")

    convert_sql_result_to_array(result)[0].id
  end

  def self.convert_sql_result_to_array(result)
    categories = []
    result.each do |row|
      category = Category.new(
        id: row['id'],
        name: row['name'],
        items: []
      )
      categories << category
    end
    categories
  end

  def self.find_category_by_id(id)
    client = create_db_client
    result = client.query("SELECT * FROM categories WHERE id = #{id}")
    convert_sql_result_to_array(result)[0]
  end

  def self.find_category_with_items_by_category_id(id)
    client = create_db_client
    result = client.query("SELECT * FROM categories WHERE id = #{id}")
    category = convert_sql_result_to_array(result)[0]
    category.items = Item.find_items_by_category_id(id)

    category
  end

  def self.find_all
    client = create_db_client
    result = client.query('SELECT * FROM categories')
    convert_sql_result_to_array(result)
  end

  def valid?
    return false if name.nil?

    true
  end

  def self.update_category(params)
    client = create_db_client
    client.query("UPDATE categories SET name = '#{params['name']}' WHERE id = #{params['id']}")
  end

end