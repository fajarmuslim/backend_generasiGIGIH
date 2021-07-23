class Item
  def initialize(param)
    @id = param[:id]
    @name = param[:name]
    @price = param[:price]
  end

  def create
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO items(id,name, price) VALUES (#{id}, #{name}, #{price}")
  end

  def read
    client = create_db_client
    client.query("SELECT * FROM items WHERE id = #{id}")
  end

  def read_all
    client = create_db_client
    client.query('SELECT * FROM items')
  end

  def delete
    client = create_db_client
    client.query("DELETE FROM items WHERE id = #{id}")
  end

  def update
    client = create_db_client
    client.query("UPDATE items SET name = #{name}, price = #{price} WHERE id = #{id}")
  end

  def valid?
    return false unless @name.nil?
    return false unless @price.nil?
  end
end
