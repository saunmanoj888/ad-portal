class AdBooking < ApplicationRecord

  validates :title, :description, presence: true
  validates :title, uniqueness: true

  belongs_to :slot
  belongs_to :user

  has_many :org_bookings

  delegate :name, to: :slot

  def run_agent_booking_expiration_job(end_time)
    AgentBookingExpirationJob.set(wait_until: end_time.noon).perform_later(self)
  end

end