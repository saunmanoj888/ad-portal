class OrgBooking < ApplicationRecord

  validates :start_time, :end_time, presence: true, availability: true
  validate :end_date_after_start_date
  validates_numericality_of :rent_amount, only_integer: true, greater_than_or_equal_to: 0

  belongs_to :user
  belongs_to :ad_booking

  scope :pending, -> { where(status: 'pending') }

  after_create :run_org_booking_expiration_job

  private

  def end_date_after_start_date
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after the start date")
    end
  end

  def run_org_booking_expiration_job
    OrgBookingExpirationJob.set(wait_until: self.end_time.noon).perform_later(self)
  end

end
