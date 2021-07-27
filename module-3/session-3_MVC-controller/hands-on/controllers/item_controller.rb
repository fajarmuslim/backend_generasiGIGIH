require 'erb'
require_relative '../utils/common'
require_relative '../models/item'
require_relative '../models/category'

class ItemController
  def show_all
    items = Item.find_all
    renderer = ERB.new(File.read('./views/item/all_item.erb'))
    renderer.result(binding)
  end

  def show_item(id)
    item = Item.find_item_with_categories(id)

    renderer = ERB.new(File.read('./views/item/item.erb'))
    renderer.result(binding)
  end

  def create_item_form
    categories = Category.find_all
    renderer = ERB.new(File.read('./views/item/create_item.erb'))
    renderer.result(binding)
  end

  def create_item(params)
    item = Item.new(
      name: params['name'],
      price: params['price']
    )
    item.save
    item_id = Item.find_id_with_name_and_price(params['name'], params['price'])

    params = Common.delete_fields_from_params(params, %w[name price])
    to_be_updated_category_ids = Common.extract_values_from_params(params)

    Category.save_item_categories_category_ids(item_id, to_be_updated_category_ids)
  end

  def self.delete_item(id)
    Item.delete_item(id)
  end

  def item_edit_form(id)
    categories = Category.find_all
    item = Item.find_item_with_categories(id)
    renderer = ERB.new(File.read('./views/item/edit_item.erb'))
    renderer.result(binding)
  end

  def self.extract_outdated_category_ids(id)
    outdated_categories = Item.find_item_with_categories(id).categories
    Common.extract_ids_from_array_obj(outdated_categories)
  end

  def self.edit_item(params)
    Item.update_item(params)
    item_id = params['id']

    outdated_category_ids = extract_outdated_category_ids(params['id'])

    params = Common.delete_fields_from_params(params, %w[name price id _method])
    to_be_updated_category_ids = Common.extract_values_from_params(params)

    Category.delete_item_categories_category_ids(item_id, outdated_category_ids)
    Category.save_item_categories_category_ids(item_id, to_be_updated_category_ids)
  end
end
