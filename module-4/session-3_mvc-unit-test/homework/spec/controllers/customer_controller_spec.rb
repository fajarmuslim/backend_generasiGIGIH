require_relative '../../controllers/customer_controller'
require_relative '../../db/mysql_connector'

describe CustomerController do
  describe '#show_all' do
    context 'show all customer' do
      it 'should show all customer view' do
        controller = CustomerController.new

        actual_view = controller.show_all

        customers = Customer.find_all
        expected_view = ERB.new(File.read('./views/customer/all_customer.erb')).result(binding)

        expect(expected_view).to eq(actual_view)
      end
    end
  end

  describe 'save' do
    context 'with valid object' do
      it 'should save to db' do
        params = {
          name: 'Fajar Muslim',
          phone: 8999999
        }
        customer = Customer.new(params)

        mock_client = double
        allow(Mysql2::Client).to receive(:new).and_return(mock_client)

        expect(mock_client).to receive(:query).with("INSERT INTO customers(name, phone) VALUES ('#{customer.name}', #{customer.phone})")
        customer.save
      end
    end
  end
end