require 'mysql2'

def create_db_client
  Mysql2::Client.new(
    host: 'localhost',
    username: 'root',
    password: 'generasiGIGIH100%',
    database: 'food_oms_db'
  )
end