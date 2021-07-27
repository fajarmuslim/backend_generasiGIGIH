require_relative '../models/customer'

class CustomerController
  def show_all
    customers = Customer.find_all
    renderer = ERB.new(File.read('./views/customer/all_customer.erb'))
    renderer.result(binding)
  end

  def show_customer(id)
    customer = Customer.find_customer_with_orders_by_customer_id(id)

    renderer = ERB.new(File.read('./views/customer/customer.erb'))
    renderer.result(binding)
  end

  def create_customer_form
    renderer = ERB.new(File.read('./views/customer/create_customer.erb'))
    renderer.result(binding)
  end

  def create_customer(params)
    customer = Customer.new(
      name: params['name'],
      phone: params['phone']
    )
    customer.save
  end

  def self.delete_customer(id)
    Customer.delete_customer(id)
  end

  def customer_edit_form(id)
    customer = Customer.find_customer_by_id(id)
    renderer = ERB.new(File.read('./views/customer/edit_customer.erb'))
    renderer.result(binding)
  end

  def self.edit_customer(params)
    Customer.update_customer(params)
  end
end