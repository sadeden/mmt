class CreatePurchaseOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_orders, id: :uuid do |t|
      t.string :source_coin_id
      t.string :destination_coin_id
      t.string :source_quantity
      t.string :destination_quantity
      t.string :source_rate
      t.string :destination_rate
      t.string :member_id

      t.timestamps
    end
  end
end
