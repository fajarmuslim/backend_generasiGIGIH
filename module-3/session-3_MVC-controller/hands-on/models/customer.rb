require_relative 'order'

class Customer
  attr_accessor :id, :name, :phone, :orders

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @phone = params[:phone]
    @orders = []
  end

  def self.find_all
    client = create_db_client
    result = client.query('SELECT * FROM customers')
    convert_sql_result_to_array(result)
  end

  def self.find_customer_with_orders_by_customer_id(id)
    client = create_db_client
    result = client.query("SELECT * FROM customers WHERE id = #{id}")
    customer = convert_sql_result_to_array(result)[0]
    customer.orders = Order.find_orders_by_customer_id(id)

    customer
  end

  def self.convert_sql_result_to_array(result)
    customers = []
    result.each do |row|
      customer = Customer.new(
        id: row['id'],
        name: row['name'],
        phone: row['phone'],
        orders: []
      )
      customers << customer
    end
    customers
  end

  def save
    return false unless valid?

    client = create_db_client
    client.query("INSERT INTO customers(name, phone) VALUES ('#{name}', #{phone})")
  end

  def valid?
    return false if name.nil? || phone.nil?

    true
  end

  def self.delete_customer(id)
    client = create_db_client
    client.query("DELETE FROM orders WHERE customer_id = #{id}")
    client.query("DELETE FROM customers WHERE id = #{id}")
  end

  def self.find_customer_by_id(id)
    client = create_db_client
    result = client.query("SELECT * FROM customers WHERE id = #{id}")
    convert_sql_result_to_array(result)[0]
  end

  def self.update_customer(params)
    client = create_db_client
    client.query("UPDATE customers SET name = '#{params['name']}', phone = #{params['phone']} WHERE id = #{params['id']}")
  end
end