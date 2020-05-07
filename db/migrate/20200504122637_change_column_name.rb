class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
  	rename_column :ad_bookings, :start_time, :title
  	rename_column :ad_bookings, :end_time, :description
  end
end
