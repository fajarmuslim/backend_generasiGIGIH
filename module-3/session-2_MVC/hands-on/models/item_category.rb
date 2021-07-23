class ItemCategory
  def initialize(param)
    @item_id = param[:item_id]
    @category_id = param[:category_id]
  end

  def create
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO item_categories(item_id, category_id) VALUES (#{@item_id}, #{@category_id}")
  end

  def read
    client = create_db_client
    client.query("SELECT * FROM item_categories WHERE item_id = #{item_id}")
  end

  def read_all
    client = create_db_client
    client.query('SELECT * FROM item_categories')
  end

  def delete
    client = create_db_client
    client.query("DELETE FROM item_categories WHERE item_id = #{item_id}")
  end

  def update
    client = create_db_client
    client.query("UPDATE item_categories SET category_id = #{category_id} WHERE item_id = #{item_id}")
  end

  def valid?
    return false unless @item_id.nil?
    return false unless @category_id.nil?
  end
end
