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
        (0..expected_result.size - 1).each  do | i |
          expect(actual_result[i].id).to eq(expected_result[i].id)
          expect(actual_result[i].name).to eq(expected_result[i].name)
          expect(actual_result[i].price).to eq(expected_result[i].price)
          expect(actual_result[i].categories).to eq(expected_result[i].categories)
        end

      end
    end
  end
end