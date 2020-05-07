class CreateAdBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :ad_bookings do |t|
    	t.belongs_to :user
    	t.belongs_to :slot
    	t.datetime :start_time
    	t.datetime :end_time

      t.timestamps
    end
  end
end
