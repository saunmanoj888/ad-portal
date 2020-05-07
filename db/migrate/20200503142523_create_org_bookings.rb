class CreateOrgBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :org_bookings do |t|
    	t.string :status, default: 'pending'
    	t.integer :rent_amount, default: 0
    	t.belongs_to :user
    	t.belongs_to :ad_booking
    	t.integer :slot_id
    	t.datetime :start_time
    	t.datetime :end_time

      t.timestamps
    end
  end
end
