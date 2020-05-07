class ChangeColumnType < ActiveRecord::Migration[6.0]
  def up
    change_column :ad_bookings, :title, :string
    change_column :ad_bookings, :description, :string
  end
  def down
    change_column :ad_bookings, :title, :datetime
    change_column :ad_bookings, :description, :datetime
  end
end
