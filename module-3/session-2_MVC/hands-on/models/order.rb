require_relative '../db/mysql_connector'

class Order
  attr_accessor :reference_no, :customer_name, :date, :items

  def initialize(param)
    @reference_no = param[:reference_no]
    @customer_name = param[:customer_name]
    @date = param[:date]
  end

  def create
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO orders(reference_no, reference_name, date) VALUES ('#{reference_no}', '#{customer_name}', '#{date}'")
  end

  def read
    client = create_db_client
    client.query("SELECT * FROM orders WHERE reference_no = #{reference_no}")
  end

  def read_all
    client = create_db_client
    client.query('SELECT * FROM orders')
  end

  def delete
    client = create_db_client
    client.query("DELETE FROM orders WHERE reference_no = #{reference_no}")
  end

  def update
    client = create_db_client
    client.query("UPDATE orders SET customer_name = #{customer_name} WHERE date = #{@date}")
  end

  def valid?
    return false unless @reference_no.nil?
    return false unless @customer_name.nil?
    return false unless @date.nil?
  end
end
