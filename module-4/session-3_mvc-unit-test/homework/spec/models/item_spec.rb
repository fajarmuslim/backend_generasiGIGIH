require_relative '../../modelsitem'
require_relative '../../db/mysql_connector'

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

    context 'not valid input' do
      it 'name nil' do
        item = Item.new({
                          id: 1,
                          price: 1000
                        })

        expect(item.valid?).to be_falsey
      end

      it 'price nil' do
        item = Item.new({
                          id: 1,
                          name: 'Nasi Uduk'
                        })

        expect(item.valid?).to be_falsey
      end
    end

  end
end


