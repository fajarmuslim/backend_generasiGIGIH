require_relative '../models/item'
require_relative '../db/mysql_connector'

describe Item do
  describe '#valid?' do
    context 'valid input' do
      it 'valid input' do
        item = Item.new({
                          id: 1,
                          name: 'Nasi uduk',
                          price: 1000
                        })


        expect(item.valid?).to eq(true)
      end
    end
  end
end


