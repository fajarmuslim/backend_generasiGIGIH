# frozen_string_literal: true

require 'erb'
require 'date'
require_relative '../models/order'
require_relative '../models/customer'

class OrderController
  def show_all
    orders = Order.find_all
    renderer = ERB.new(File.read('./views/order/all_order.erb'))
    renderer.result(binding)
  end

  def show_order(id)
    order = Order.find_order_with_details(id)

    renderer = ERB.new(File.read('./views/order/order.erb'))
    renderer.result(binding)
  end

  def create_order_form
    customers = Customer.find_all
    items = Item.find_all
    renderer = ERB.new(File.read('./views/order/create_order.erb'))
    renderer.result(binding)
  end

  def self.get_item_id_quantity(params)
    item_id_quantity = {}

    params.each do |key, value|
      key_ = key.partition('_quantity')[0]
      item_id_quantity[key_] = value.to_i if key.to_s.include?('_quantity') && (value != '0')
    end
    item_id_quantity
  end

  def self.create_order(params)
    item_id_quantity = get_item_id_quantity(params)
    items = []
    total_price = 0

    item_id_quantity.each do |item_id, quantity|
      item = Item.find_item_by_id(item_id)
      items << item

      price = item.price
      total_price += price * quantity
    end

    order = Order.new(
      customer_id: params['customer_id'],
      date: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      total_price: total_price
    )
    order.save

    order_id = Order.find_order_id(order.customer_id, order.date, order.total_price)

    (0..items.length - 1).each do |i|
      order_detail = OrderDetail.new(
        order_id: order_id,
        item: items[i],
        quantity: item_id_quantity.values[i]
      )
      order_detail.save
    end
  end

  def self.delete_order(order_id)
    Order.delete_order(order_id)
  end

  def order_edit_form(id)
    items = Item.find_all
    customers = Customer.find_all
    order = Order.find_order_with_details(id)

    renderer = ERB.new(File.read('./views/order/edit_order.erb'))
    renderer.result(binding)
  end

  def self.edit_order(params)
    order_id = params['order_id']

    # delete order detail
    OrderDetail.delete_order_details(order_id)

    # re-create order detail from new params
    item_id_quantity = get_item_id_quantity(params)
    total_price = 0

    (0..item_id_quantity.length - 1).each do |i|
      item = Item.find_item_by_id(item_id_quantity.keys[i])
      quantity = item_id_quantity.values[i]
      price = item.price
      total_price += price * quantity

      order_detail = OrderDetail.new(
        order_id: order_id,
        item: item,
        quantity: quantity
      )
      order_detail.save
    end
    puts "total_price: #{total_price}"
    Order.update_order(params, total_price)
  end
end
