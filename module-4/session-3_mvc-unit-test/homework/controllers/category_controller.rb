require 'erb'
require_relative '../utils/common'
require_relative '../models/category'
require_relative '../models/item'

class CategoryController
  def show_all
    categories = Category.find_all
    renderer = ERB.new(File.read('./views/category/all_category.erb'))
    renderer.result(binding)
  end

  def show_category(id)
    category = Category.find_category_with_items_by_category_id(id)

    renderer = ERB.new(File.read('./views/category/category.erb'))
    renderer.result(binding)
  end

  def create_category_form
    items = Item.find_all
    renderer = ERB.new(File.read('./views/category/create_category.erb'))
    renderer.result(binding)
  end

  def create_category(params)
    category = Category.new(
      name: params['name']
    )
    puts category.name

    category.save

    category_id = Category.find_id_with_name(params['name'])

    params = Common.delete_fields_from_params(params, ['name'])
    to_be_updated_item_ids = Common.extract_values_from_params(params)

    Item.save_category_items(category_id, to_be_updated_item_ids)
  end

  def self.delete_category(id)
    Category.delete_category(id)
  end

  def category_edit_form(id)
    items = Item.find_all
    category = Category.find_category_with_items_by_category_id(id)
    renderer = ERB.new(File.read('./views/category/edit_category.erb'))
    renderer.result(binding)
  end

  def self.extract_outdated_item_ids(id)
    outdated_items = Category.find_category_with_items_by_category_id(id).items
    Common.extract_ids_from_array_obj(outdated_items)
  end

  def self.edit_item(params)
    Category.update_category(params)
    category_id = Category.find_id_with_name(params['name'])

    outdated_item_ids = extract_outdated_item_ids(params['id'])

    params = Common.delete_fields_from_params(params, %w[name id _method])
    to_be_updated_item_ids = Common.extract_values_from_params(params)

    Item.delete_item_categories_item_ids(category_id, outdated_item_ids)
    Item.save_item_categories_item_ids(category_id, to_be_updated_item_ids)
  end
end
