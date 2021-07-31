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

end


