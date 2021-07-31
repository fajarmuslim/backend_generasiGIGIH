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
        expect(item.name).to eq(params [:name])
        expect(item.price).to eq(params [:price])
        expect(item.categories).to eq([])
      end
    end
  end
end


