class ChangeColumnTypeForOrgBooking < ActiveRecord::Migration[6.0]
  def up
    change_column :org_bookings, :start_time, :date
    change_column :org_bookings, :end_time, :date
  end
  def down
    change_column :org_bookings, :start_time, :datetime
    change_column :org_bookings, :end_time, :datetime
  end
end
