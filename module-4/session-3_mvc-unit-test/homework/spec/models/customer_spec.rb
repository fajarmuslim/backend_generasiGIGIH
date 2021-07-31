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

  describe '.find_all' do
    context 'find all customers' do
      it 'should returning all customers from db' do

        query_result_mock = [
          { "id" => 1, "name" => "Budiawan", "phone" => "80123123123" },
          { "id" => 2, "name" => "Mary Jones", "phone" => "81123123123" },
          { "id" => 3, "name" => "Bima", "phone" => "82123123123" }
        ]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with('SELECT * FROM customers').and_return(query_result_mock)

        actual_result = Customer.find_all
        expected_customer_1 = Customer.new({ id: 1, name: "Budiawan", phone: "80123123123" })
        expected_customer_2 = Customer.new({ id: 2, name: "Mary Jones", phone: "81123123123" })
        expected_customer_3 = Customer.new({ id: 3, name: "Bima", phone: "82123123123" })


        expected_result = [
          expected_customer_1,
          expected_customer_2,
          expected_customer_3
        ]

        expect(expected_result.size).to eq(actual_result.size)
        (0..expected_result.size - 1).each do |i|
          expect(actual_result[i].id).to eq(expected_result[i].id)
          expect(actual_result[i].name).to eq(expected_result[i].name)
          expect(actual_result[i].phone).to eq(expected_result[i].phone)
          expect(actual_result[i].orders).to eq(expected_result[i].orders)
        end
      end
    end
  end
end