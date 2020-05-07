class AvailabilityValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    bookings = OrgBooking.where(["user_id =?", record.user_id]).where.not(status: 'rejected')
    date_ranges = bookings.map { |b| b.start_time..b.end_time }

    date_ranges.each do |range|
      if range.include? value
        record.errors.add(attribute, "not available")
      end
    end
  end

end