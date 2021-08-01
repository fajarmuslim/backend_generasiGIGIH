require_relative '../../models/order'
require_relative '../../db/mysql_connector'

describe Item do
  describe '#valid?' do
    context 'valid input' do
      it 'valid input' do
        params = {
          id: 1,
          customer_id: 1,
          date: '2021-07-01 01:01:01',
          total_price: 52000
        }

        order = Order.new(params)

        expect(order.valid?).to eq(true)
      end
    end

    context 'valid input' do
      it 'customer id nil' do
        params = {
          id: 1,
          date: '2021-07-01 01:01:01',
          total_price: 52000
        }

        order = Order.new(params)

        expect(order.valid?).to be_falsey
      end
    end

    context 'valid input' do
      it 'date nil' do
        params = {
          id: 1,
          customer_id: 1,
          total_price: 52000
        }

        order = Order.new(params)

        expect(order.valid?).to be_falsey
      end
    end

    context 'valid input' do
      it 'total price nil' do
        params = {
          id: 1,
          customer_id: 1,
          date: '2021-07-01 01:01:01'
        }

        order = Order.new(params)

        expect(order.valid?).to be_falsey
      end
    end
  end

  describe '#save' do
    context 'valid input' do
      it 'should save data to db' do
        params = {
          id: 1,
          customer_id: 1,
          date: '2021-07-01 01:01:01',
          total_price: 52000
        }

        order = Order.new(params)

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)

        expect(mock_client).to receive(:query).with("INSERT INTO orders(customer_id, date, total_price) VALUES (#{params[:customer_id]}, '#{params[:date]}', #{params[:total_price]})")
        order.save
      end
    end
  end

  describe '.find_all' do
    context 'find all orders' do
      it 'should returning all orders from db' do
        query_result_mock = [
          { "id" => 1, "customer_id" => 1, "date" => '2021 - 07 - 01 01 : 01 : 01', "total_price" => 52000 },
          { "id" => 2, "customer_id" => 1, "date" => '2021 - 07 - 01 02 : 02 : 02', "total_price" => 71000 },
          { "id" => 3, "customer_id" => 2, "date" => '2021 - 07 - 01 03 : 03 : 03', "total_price" => 72000 },
        ]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with('SELECT * FROM orders').and_return(query_result_mock)

        actual_result = Order.find_all
        expected_order_1 = Order.new({ id: 1, customer_id: 1, date: '2021 - 07 - 01 01 : 01 : 01', total_price: 52000 })
        expected_order_2 = Order.new({ id: 2, customer_id: 1, date: '2021 - 07 - 01 02 : 02 : 02', total_price: 71000 })
        expected_order_3 = Order.new({ id: 3, customer_id: 2, date: '2021 - 07 - 01 03 : 03 : 03', total_price: 72000 })

        expected_result = [
          expected_order_1,
          expected_order_2,
          expected_order_3
        ]

        expect(expected_result.size).to eq(actual_result.size)
        (0..expected_result.size - 1).each do |i|
          expect(actual_result[i].id).to eq(expected_result[i].id)
          expect(actual_result[i].customer_id).to eq(expected_result[i].customer_id)
          expect(actual_result[i].date).to eq(expected_result[i].date)
          expect(actual_result[i].total_price).to eq(expected_result[i].total_price)
        end
      end
    end
  end
end