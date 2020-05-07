class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum category: [:organisations, :ad_space_provider, :ad_space_agent]

  validates :first_name, :last_name, :category, presence: true
  validates_uniqueness_of :email, case_sensitive: true

  has_many :slots
  has_many :ad_bookings
  has_many :org_bookings

  def unavailable_dates
    org_bookings.pending.or(OrgBooking.where(status: "accepted")).pluck(:start_time, :end_time).map do |range|
      { from: range[0], to: range[1] }
    end
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
