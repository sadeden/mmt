class IncreaseIntLimit < ActiveRecord::Migration[5.0]
  def change
    change_column :coins, :central_reserve_in_sub_units, :integer, limit: 8
    change_column :holdings, :quantity, :integer, limit: 8
  end
end
