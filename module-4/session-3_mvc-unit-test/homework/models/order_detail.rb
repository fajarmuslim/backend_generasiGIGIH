require_relative '../models/item'

class OrderDetail
  attr_accessor :order_id, :item, :quantity

  def initialize(params)
    @order_id = params[:order_id]
    @item = params[:item]
    @quantity = params[:quantity]
  end

  def save
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO order_details(order_id, item_id, quantity) VALUES(#{order_id}, #{item.id}, #{quantity})")
  end

  def valid?
    return false if order_id.nil? || item.nil? || quantity.nil?

    true
  end

  def self.find_order_details_by_order_id(order_id)
    client = create_db_client
    result = client.query("SELECT * FROM order_details WHERE order_id = #{order_id}")
    convert_sql_result_to_array(result)
  end

  def self.convert_sql_result_to_array(result)
    order_details = []
    result.each do |row|
      item = Item.find_item_by_id(row['item_id'])
      order_detail = OrderDetail.new(
        order_id: row['order_id'],
        item: item,
        quantity: row['quantity']
      )
      order_details << order_detail
    end
    order_details
  end

  def self.delete_order_details(order_id)
    client = create_db_client
    client.query("DELETE FROM order_details WHERE order_id = #{order_id}")
  end
end