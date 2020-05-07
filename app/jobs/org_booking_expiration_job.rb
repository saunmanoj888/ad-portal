class OrgBookingExpirationJob < ApplicationJob
  queue_as :default

  def perform(org_booking)
    org_booking.update_attribute(:status, 'expired')
  end
end
