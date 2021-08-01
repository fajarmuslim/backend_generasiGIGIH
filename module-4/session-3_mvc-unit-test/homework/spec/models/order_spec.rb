require_relative '../../models/order'
require_relative '../../models/order_detail'
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
    describe '.find_order_with_details' do
      context 'find order with item details based on order id' do
        it 'should returning order with item details' do
          Order.find_order_with_details(1)
          id = 1
          query_result_mock_order = [
            { "id" => 1, "customer_id" => 1, "date" => "2021-07-01 01:01:01", "total_price" => 52000 }
          ]

          item_1 = Item.new(id: 1,
                            name: "Nasi Goreng Gila",
                            price: 25000
          )

          detail_1 = OrderDetail.new({ order_id: 1,
                                       item: item_1,
                                       quantity: 2
                                     })

          item_2 = Item.new(id: 1,
                            name: "Ice Water",
                            price: 2000
          )

          detail_2 = OrderDetail.new({ order_id: 1,
                                       item: item_2,
                                       quantity: 1
                                     })
          mock_detail_of_order = [detail_1, detail_2]

          mock_client = double
          allow(Mysql2::Client).to receive(:new).and_return(mock_client)
          allow(mock_client).to receive(:query).with("SELECT * FROM orders WHERE id = #{id}").and_return(query_result_mock_order)

          allow(OrderDetail).to receive(:find_order_details_by_order_id).with(id).and_return(mock_detail_of_order)
          actual_result = Order.find_order_with_details(1)

          expected_result = Order.new({ id: 1, customer_id: 1, date: "2021-07-01 01:01:01", total_price: 52000 } )
          expected_result.details = [detail_1, detail_2]
          expect(actual_result.id).to eq(expected_result.id)
          expect(actual_result.customer_id).to eq(expected_result.customer_id)
          expect(actual_result.date).to eq(expected_result.date)
          expect(actual_result.total_price).to eq(expected_result.total_price)

          expect(actual_result.details.size).to eq(expected_result.details.size)
          (0..actual_result.details.size - 1).each do |i|
            expect(actual_result.details[i].order_id).to eq(expected_result.details[i].order_id)
            expect(actual_result.details[i].item.id).to eq(expected_result.details[i].item.id)
            expect(actual_result.details[i].item.name).to eq(expected_result.details[i].item.name)
            expect(actual_result.details[i].item.price).to eq(expected_result.details[i].item.price)
            expect(actual_result.details[i].item.categories).to eq(expected_result.details[i].item.categories)
            expect(actual_result.details[i].quantity).to eq(expected_result.details[i].quantity)
          end
        end
      end
    end
  end

  describe '.find_order_id' do
    context 'find order id based on customer id, date, and price' do
      it 'should returning order id based on customer id, date, and price' do
        customer_id = 1
        date = '2021-07-01 01:01:01'
        total_price = 52000

        query_result_mock_order = [
          { "id" => 1, "customer_id" => customer_id, "date" => date, "total_price" => total_price }
        ]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with("SELECT * FROM orders WHERE customer_id=#{customer_id} AND date='#{date}' AND total_price=#{total_price}").and_return(query_result_mock_order)

        actual_id = Order.find_order_id(customer_id, date, total_price)
        expected_id = 1
        expect(actual_id).to eq(expected_id)
      end
    end
  end
end