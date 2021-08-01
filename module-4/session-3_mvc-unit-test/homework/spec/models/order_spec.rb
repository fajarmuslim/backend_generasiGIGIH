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
end