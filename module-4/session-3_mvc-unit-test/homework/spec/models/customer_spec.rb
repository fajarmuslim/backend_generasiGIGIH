require_relative '../../models/customer'
require_relative '../../db/mysql_connector'

describe Item do
  describe '#valid?' do
    context 'valid input' do
      it 'valid input' do
        params = {
          name: 'Budi',
          phone: 9999999
        }

        customer = Customer.new(params)

        expect(customer.valid?).to eq(true)
      end
    end

    context 'not valid input' do
      it 'name nil' do
        params = {
          name: nil,
          phone: 9999999
        }

        customer = Customer.new(params)

        expect(customer.valid?).to be_falsey
      end

      it 'phone nil' do
        params = {
          name: 'Budi',
          phone: nil
        }

        customer = Customer.new(params)

        expect(customer.valid?).to be_falsey
      end
    end
  end

  describe '.initialize' do
    context 'valid input' do
      it 'valid input' do
        params = {
          id: 1,
          name: 'Budi',
          phone: 9999999
        }

        customer = Customer.new(params)

        expect(customer.id).to eq(params[:id])
        expect(customer.name).to eq(params[:name])
        expect(customer.phone).to eq(params[:phone])
        expect(customer.orders).to eq([])
      end
    end
  end
end