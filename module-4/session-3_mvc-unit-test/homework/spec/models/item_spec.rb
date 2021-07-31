# frozen_string_literal: true

require_relative '../../models/item'
require_relative '../../db/mysql_connector'

describe Item do
  describe '#valid?' do
    context 'valid input' do
      it 'valid input' do
        params = {
          id: 1,
          name: 'Nasi uduk',
          price: 1000
        }

        item = Item.new(params)

        expect(item.valid?).to eq(true)
      end
    end

    context 'not valid input' do
      it 'name nil' do
        params = {
          id: 1,
          price: 1000
        }

        item = Item.new(params)

        expect(item.valid?).to be_falsey
      end

      it 'price nil' do
        params = {
          id: 1,
          name: 'Nasi Uduk'
        }

        item = Item.new(params)

        expect(item.valid?).to be_falsey
      end
    end
  end

  describe '.initialize' do
    context 'valid input' do
      it 'valid input' do
        params = {
          id: 1,
          name: 'Nasi uduk',
          price: 1000
        }

        item = Item.new(params)

        expect(item.id).to eq(params [:id])
        expect(item.name).to eq(params [:name])
        expect(item.price).to eq(params [:price])
        expect(item.categories).to eq([])
      end

      it 'valid input: id nil' do
        params = {
          name: 'Nasi uduk',
          price: 1000
        }

        item = Item.new(params)

        expect(item.id).to eq(nil)
        expect(item.name).to eq(params[:name])
        expect(item.price).to eq(params[:price])
        expect(item.categories).to eq([])
      end

      it 'valid input: name nil' do
        params = {
          id: 1,
          price: 1000
        }

        item = Item.new(params)

        expect(item.id).to eq(params[:id])
        expect(item.name).to eq(nil)
        expect(item.price).to eq(params[:price])
        expect(item.categories).to eq([])
      end

      it 'valid input: price nil' do
        params = {
          id: 1,
          name: 'Nasi Uduk',
          price: nil
        }

        item = Item.new(params)

        expect(item.id).to eq(params[:id])
        expect(item.name).to eq(params[:name])
        expect(item.price).to eq(nil)
        expect(item.categories).to eq([])
      end
    end
  end

  describe '#save' do
    context 'valid input' do
      it 'should save data to db' do
        params = {
          name: 'Nasi Uduk',
          price: 1000
        }

        item = Item.new(params)

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)

        expect(mock_client).to receive(:query).with("INSERT INTO items(name, price) VALUES ('#{item.name}', #{item.price})")
        item.save
      end
    end
  end

  describe '.save_category_items' do
    context 'save items of an category' do
      it 'should save items of an category into db' do
        item_ids = [1, 2, 3]
        category_id = 1

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)

        item_ids.each do |item_id|
          expect(mock_client).to receive(:query).with("INSERT INTO item_categories (item_id, category_id) VALUES (#{item_id}, #{category_id})")
        end

        Item.save_category_items(category_id, item_ids)
      end
    end
  end

  describe '.find_all' do
    context 'find all items' do
      it 'should returning all items from db' do
        query_result_mock = [
          { "id" => 1, "name" => "Nasi Goreng Gila", "price" => 25000 },
          { "id" => 2, "name" => "Ice Water", "price" => 2000 },
          { "id" => 3, "name" => "Spaghetti", "price" => 40000 }
        ]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with('SELECT * FROM items').and_return(query_result_mock)

        actual_result = Item.find_all
        expected_item_1 = Item.new({ id: 1, name: "Nasi Goreng Gila", price: 25000 })
        expected_item_2 = Item.new({ id: 2, name: "Ice Water", price: 2000 })
        expected_item_3 = Item.new({ id: 3, name: "Spaghetti", price: 40000 })

        expected_result = [
          expected_item_1,
          expected_item_2,
          expected_item_3
        ]

        expect(expected_result.size).to eq(actual_result.size)
        (0..expected_result.size - 1).each do |i|
          expect(actual_result[i].id).to eq(expected_result[i].id)
          expect(actual_result[i].name).to eq(expected_result[i].name)
          expect(actual_result[i].price).to eq(expected_result[i].price)
          expect(actual_result[i].categories).to eq(expected_result[i].categories)
        end
      end
    end
  end

  describe '.find_item_by_id' do
    context 'find single item by id' do
      it 'should returning single item based on id' do
        query_result_mock = [{ "id" => 1, "name" => "Nasi Goreng Gila", "price" => 25000 }]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with('SELECT * FROM items WHERE id = 1').and_return(query_result_mock)

        actual_result = Item.find_item_by_id(1)
        expected_result = Item.new({ id: 1, name: "Nasi Goreng Gila", price: 25000 })

        expect(actual_result.id).to eq(expected_result.id)
        expect(actual_result.name).to eq(expected_result.name)
        expect(actual_result.price).to eq(expected_result.price)
        expect(actual_result.categories).to eq(expected_result.categories)
      end
    end
  end

  describe '.find_items_by_category_id' do
    context 'find items of a category based on category_id' do
      it 'should returning items based on category_id' do
        query_result_mock_item_categories = [
          { "item_id" => 1, "category_id" => 1 },
          { "item_id" => 3, "category_id" => 1 },
          { "item_id" => 7, "category_id" => 1 }
        ]

        query_result_mock_item_1 = [{ "id" => 1, "name" => "Nasi Goreng Gila", "price" => 25000 }]
        query_result_mock_item_2 = [{ "id" => 3, "name" => "Spaghetti", "price" => 40000 }]
        query_result_mock_item_3 = [{ "id" => 7, "name" => "Cordon Blue", "price" => 36000 }]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with('SELECT * FROM item_categories WHERE category_id = 1').and_return(query_result_mock_item_categories)
        allow(mock_client).to receive(:query).with('SELECT * FROM items WHERE id = 1').and_return(query_result_mock_item_1)
        allow(mock_client).to receive(:query).with('SELECT * FROM items WHERE id = 3').and_return(query_result_mock_item_2)
        allow(mock_client).to receive(:query).with('SELECT * FROM items WHERE id = 7').and_return(query_result_mock_item_3)

        item_1 = Item.new({ id: 1, name: "Nasi Goreng Gila", price: 25000 })
        item_2 = Item.new({ id: 3, name: "Spaghetti", price: 40000 })
        item_3 = Item.new({ id: 7, name: "Cordon Blue", price: 36000 })

        expected_result = [item_1, item_2, item_3]
        actual_result = Item.find_items_by_category_id(1)

        expect(expected_result.size).to eq(actual_result.size)
        (0..expected_result.size - 1).each do |i|
          expect(actual_result[i].id).to eq(expected_result[i].id)
          expect(actual_result[i].name).to eq(expected_result[i].name)
          expect(actual_result[i].price).to eq(expected_result[i].price)
          expect(actual_result[i].categories).to eq(expected_result[i].categories)
        end
      end
    end
  end

  describe '.find_id_with_name_and_price' do
    context 'find id based on name and price' do
      it 'should returning id based on name and price' do
        query_result_mock_item = [{ "id" => 1, "name" => "Nasi Goreng Gila", "price" => 25000 }]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with("SELECT id FROM items WHERE name = 'Nasi Goreng Gila' AND price = 25000").and_return(query_result_mock_item)

        actual_id = Item.find_id_with_name_and_price('Nasi Goreng Gila', 25000)
        expected_id = 1
        expect(actual_id).to eq(expected_id)
      end
    end
  end

  describe '.convert_sql_result_to_array' do
    context 'convert sql result into an array' do
      it 'should returning an array of item object' do
        sql_result = [
          { "id" => 1, "name" => "Nasi Goreng Gila", "price" => 25000 },
          { "id" => 2, "name" => "Ice Water", "price" => 2000 },
          { "id" => 3, "name" => "Spaghetti", "price" => 40000 }
        ]

        expected_item_1 = Item.new({ id: 1, name: "Nasi Goreng Gila", price: 25000 })
        expected_item_2 = Item.new({ id: 2, name: "Ice Water", price: 2000 })
        expected_item_3 = Item.new({ id: 3, name: "Spaghetti", price: 40000 })

        actual_array = Item.convert_sql_result_to_array(sql_result)
        expected_array = [expected_item_1, expected_item_2, expected_item_3]

        expect(expected_array.size).to eq(actual_array.size)
        (0..expected_array.size - 1).each do |i|
          expect(actual_array[i].id).to eq(expected_array[i].id)
          expect(actual_array[i].name).to eq(expected_array[i].name)
          expect(actual_array[i].price).to eq(expected_array[i].price)
          expect(actual_array[i].categories).to eq(expected_array[i].categories)
        end
      end
    end
  end

  describe '.update_item' do
    context 'update an item' do
      it 'should success update an item' do
        params = {
          id: 1,
          name: 'Nasi uduk',
          price: 1000
        }
        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        expect(mock_client).to receive(:query).with("UPDATE items SET name = '#{params['name']}', price = #{params['price']} WHERE id = #{params['id']}")

        Item.update_item(params)
      end
    end
  end

  describe '.delete_item' do
    context 'delete an item' do
      it 'should success delete an item' do
        id = 1

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        expect(mock_client).to receive(:query).with("DELETE FROM item_categories WHERE item_id = #{id}")
        expect(mock_client).to receive(:query).with("DELETE FROM items WHERE id = #{id}")

        Item.delete_item(id)
      end
    end
  end

  describe '.delete_item_categories_item_ids' do
    context 'delete categories of an item' do
      it 'should success delete categories of an item' do
        category_id = 1
        item_ids = [1,2,3]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)

        item_ids.each do |item_id|
          expect(mock_client).to receive(:query).with("DELETE FROM item_categories WHERE item_id = #{item_id} AND category_id = #{category_id}")
        end

        Item.delete_item_categories_item_ids(category_id, item_ids)
      end
    end
  end

  describe '.save_item_categories_item_ids' do
    context 'save categories of an item' do
      it 'should success save categories of an item' do
        category_id = 1
        item_ids = [1,2,3]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)

        item_ids.each do |item_id|
          expect(mock_client).to receive(:query).with("INSERT INTO item_categories (item_id, category_id) VALUES (#{item_id}, #{category_id})")
        end

        Item.save_item_categories_item_ids(category_id, item_ids)
      end
    end
  end
end