require_relative '../db/mysql_connector'
require_relative '../models/order_detail'

class Order
  attr_accessor :id, :customer_id, :date, :total_price, :details

  def initialize(params)
    @id = params[:id]
    @customer_id = params[:customer_id]
    @date = params[:date]
    @total_price = params[:total_price]
    @details = []
  end

  def save
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO orders(customer_id, date, total_price) VALUES (#{customer_id}, '#{date}', #{total_price})")
  end

  def valid?
    return false if customer_id.nil? || date.nil? || total_price.nil?

    true
  end

  def self.find_all
    client = create_db_client
    result = client.query('SELECT * FROM orders')
    convert_sql_result_to_array(result)
  end

  def self.find_order_with_details(id)
    client = create_db_client
    result = client.query("SELECT * FROM orders WHERE id = #{id}")
    order = convert_sql_result_to_array(result)[0]
    order.details = OrderDetail.find_order_details_by_order_id(id)

    order
  end

  def self.find_order_id(customer_id, date, total_price)
    client = create_db_client
    result = client.query("SELECT * FROM orders WHERE customer_id=#{customer_id} AND date='#{date}' AND total_price=#{total_price}")
    convert_sql_result_to_array(result)[0].id
  end

  def self.find_orders_by_customer_id(customer_id)
    client = create_db_client
    result = client.query("SELECT * FROM orders WHERE customer_id = #{customer_id}")
    orders = []
    result.each do |row|
      orders << find_order_by_id(row['id'])
    end

    orders
  end

  def self.find_order_by_id(id)
    client = create_db_client
    result = client.query("SELECT * FROM orders WHERE id = #{id}")

    convert_sql_result_to_array(result)[0]
  end

  def self.convert_sql_result_to_array(result)
    orders = []
    result.each do |row|
      order = Order.new(
        id: row['id'],
        customer_id: row['customer_id'],
        date: row['date'],
        total_price: row['total_price'],
        details: []
      )
      orders << order
    end
    orders
  end

  def self.delete_order(order_id)
    OrderDetail.delete_order_details(order_id)

    client = create_db_client
    client.query("DELETE FROM orders WHERE id = #{order_id}")
  end

  def self.extract_quantity_from_order_details(order_detail)
    quantities = []
    order_detail.each do |detail|
      quantities << detail.quantity
    end

    quantities
  end

  def self.extract_prev_item_ids(order_details)
    item_ids = []
    order_details.each do |detail|
      item_ids << detail.item.id
    end

    item_ids
  end

  def self.find_quantity_params(params)
    params_new = {}
    params.each do |key, value|
      params_new[key] = value if key.include? '_quantity_price_'
    end

    params_new
  end

  def self.update_order(params, total_price)
    client = create_db_client
    client.query("UPDATE orders SET customer_id = '#{params['customer_id']}', total_price=#{total_price} WHERE id = #{params['order_id']}")
  end
end
