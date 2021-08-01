require_relative '../../models/customer'
require_relative '../../models/order'
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

  describe '.find_customer_with_orders_by_customer_id' do
    context 'find customer with orders by customer id' do
      it 'should returning customers with orders' do
        id = 1
        query_result_mock_customer = [
          { "id" => 1, "name" => "Budiawan", "phone" => "80123123123" }
        ]

        order_1 = Order.new({ id: 1,
                              customer_id: 1,
                              date: '2021-07-01 01:01:01',
                              total_price: 52000
                            })

        order_2 = Order.new({ id: 2,
                              customer_id: 1,
                              date: '2021-07-01 02:02:02',
                              total_price: 71000
                            })
        mock_order_of_customers = [order_1, order_2]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with("SELECT * FROM customers WHERE id = #{id}").and_return(query_result_mock_customer)

        allow(Order).to receive(:find_orders_by_customer_id).with(id).and_return(mock_order_of_customers)
        actual_result = Customer.find_customer_with_orders_by_customer_id(1)

        expected_result = Customer.new({ id: 1, name: "Budiawan", phone: "80123123123" })
        expected_result.orders = [order_1, order_2]
        expect(actual_result.id).to eq(expected_result.id)
        expect(actual_result.name).to eq(expected_result.name)
        expect(actual_result.phone).to eq(expected_result.phone)

        (0..actual_result.orders.size - 1).each do |i|
          expect(actual_result.orders[i].id).to eq(expected_result.orders[i].id)
          expect(actual_result.orders[i].customer_id).to eq(expected_result.orders[i].customer_id)
          expect(actual_result.orders[i].date).to eq(expected_result.orders[i].date)
          expect(actual_result.orders[i].details).to eq(expected_result.orders[i].details)
        end
      end
    end
  end

  describe '.convert_sql_result_to_array' do
    context 'convert sql result into an array' do
      it 'should returning an array of customer object' do
        sql_result = [
          { "id" => 1, "name" => "Budiawan", "phone" => "80123123123" },
          { "id" => 2, "name" => "Mary Jones", "phone" => "81123123123" },
          { "id" => 3, "name" => "Bima", "phone" => "82123123123" }
        ]

        expected_customer_1 = Customer.new({ id: 1, name: "Budiawan", phone: '80123123123' })
        expected_customer_2 = Customer.new({ id: 2, name: "Mary Jones", phone: '81123123123' })
        expected_customer_3 = Customer.new({ id: 3, name: "Bima", phone: '82123123123' })

        actual_array = Customer.convert_sql_result_to_array(sql_result)
        expected_array = [expected_customer_1, expected_customer_2, expected_customer_3]

        expect(expected_array.size).to eq(actual_array.size)
        (0..expected_array.size - 1).each do |i|
          expect(actual_array[i].id).to eq(expected_array[i].id)
          expect(actual_array[i].name).to eq(expected_array[i].name)
          expect(actual_array[i].phone).to eq(expected_array[i].phone)
          expect(actual_array[i].orders).to eq(expected_array[i].orders)
        end
      end
    end
  end

  describe '#save' do
    context 'valid input' do
      it 'should save data to db' do
        params = { id: 1, name: "Budiawan", phone: "80123123123" }
        customer = Customer.new(params)

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)

        expect(mock_client).to receive(:query).with("INSERT INTO customers(name, phone) VALUES ('#{customer.name}', #{customer.phone})")
        customer.save
      end
    end
  end

  describe '.delete_customer' do
    context 'delete an customer' do
      it 'should success delete an customer' do
        id = 1

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        expect(mock_client).to receive(:query).with("DELETE FROM orders WHERE customer_id = #{id}")
        expect(mock_client).to receive(:query).with("DELETE FROM customers WHERE id = #{id}")

        Customer.delete_customer(id)
      end
    end
  end

  describe '.find_customer_by_id' do
    context 'find single customer by id' do
      it 'should returning single customer based on id' do
        id = 1
        query_result_mock = [{ "id" => 1, "name" => "Budiawan", "phone" => "80123123123" }]

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:query).with("SELECT * FROM customers WHERE id = #{id}").and_return(query_result_mock)

        actual_result = Customer.find_customer_by_id(1)
        expected_result = Customer.new({ id: 1, name: "Budiawan", phone: "80123123123" })

        expect(actual_result.id).to eq(expected_result.id)
        expect(actual_result.name).to eq(expected_result.name)
        expect(actual_result.phone).to eq(expected_result.phone)
        expect(actual_result.orders).to eq(expected_result.orders)
      end
    end
  end

  describe '.update_customer' do
    context 'update an customer' do
      it 'should success update an customer' do
        params = {
          "id" => 1, "name" => "Budiawan", "phone" => "80123123123"
        }
        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)
        expect(mock_client).to receive(:query).with("UPDATE customers SET name = '#{params['name']}', phone = #{params['phone']} WHERE id = #{params['id']}")

        Customer.update_customer(params)
      end
    end
  end
end