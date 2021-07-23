class Category
  def initialize(param)
    @category_id = param[:category_id]
    @name = param[:name]
  end

  def create
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO categories(name) VALUES (#{name}, #{category_id}")
  end

  def read
    client = create_db_client
    client.query("SELECT * FROM categories WHERE category_id = #{category_id}")
  end

  def read_all
    client = create_db_client
    client.query('SELECT * from categories')
  end

  def delete
    client = create_db_client
    client.query("DELETE FROM categories WHERE category_id = #{category_id}")
  end

  def update
    client = create_db_client
    client.query("UPDATE categories SET name = #{name} WHERE category_id = #{category_id}")
  end

  def valid?
    return false unless @name.nil?
  end
end