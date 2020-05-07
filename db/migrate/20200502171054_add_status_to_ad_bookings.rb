class AddStatusToAdBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :ad_bookings, :status, :string, default: 'vacant'
  end
end
