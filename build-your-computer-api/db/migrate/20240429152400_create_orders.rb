class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :client_name
      t.json :order

      t.timestamps
    end
  end
end
