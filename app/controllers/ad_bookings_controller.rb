class AdBookingsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_user_type
  before_action :find_accepted_booking, only: :show

  def index
    @booked_slots = AdBooking.where(user_id: current_user.id)
  end

  def vacant_slots
    ids = AdBooking.all.pluck(:slot_id)
    @vacant_slots = Slot.where.not(id: ids)
  end

  def new
     @slot = Slot.find(params[:slot_id])
     @ad_booking = AdBooking.new
  end

  def create
    @ad_booking = AdBooking.new(ad_bookings_params)

    if @ad_booking.save
      AgentMailer.delay.slot_booking_mail(@ad_booking, current_user)
      redirect_to ad_bookings_path, notice: 'Slot was successfully Pre Booked.'
    else
      render :new
    end
  end

  def show
  end

  def accept_bid
    agent_booking = AdBooking.find(params[:id])
    org_booking = OrgBooking.find(params[:org_booking_id])
    if validate_organisation_bid(org_booking)
      accept_bid_and_send_confirmation_mail(org_booking)
      reject_bid_and_send_rejection_mail(agent_booking, org_booking)
      agent_booking.update_attribute(:status, 'occupied')
      agent_booking.run_agent_booking_expiration_job(org_booking.end_time)
      message = { notice: 'Bid accepted successfully' }
    else
      OrganisationMailer.delay.date_change_mail(org_booking.user_id, org_booking.slot_id)
      message = { alert: 'Dates overlapping. Emailed User to change the dates' }
    end
    redirect_to ad_booking_path(agent_booking), message
  end

  private

  def accept_bid_and_send_confirmation_mail(org_booking)
    org_booking.update_attribute(:status, 'accepted')
    OrganisationMailer.delay.bid_confirmation_mail(org_booking.user_id, org_booking.slot_id)
  end

  def reject_bid_and_send_rejection_mail(agent_booking, org_booking)
    rejected_bookings = agent_booking.org_bookings.where.not(id: params[:org_booking_id])
    rejected_bookings.update_all(status: 'rejected')
    rejected_user_ids = rejected_bookings.pluck(:user_id)
    rejected_user_ids.each do |user_id|
      OrganisationMailer.delay.bid_rejection_mail(user_id, org_booking.slot_id)
    end
  end

  def authenticate_user_type
    unless current_user.ad_space_agent?
      redirect_to root_path, alert: 'Access denied. You are not ad space agent'
    end
  end

  def ad_bookings_params
    params.require(:ad_booking).permit(:title, :description, :slot_id, :user_id)
  end

  def validate_organisation_bid(org_booking)
    bookings = OrgBooking.where(status: 'accepted')
    date_ranges = bookings.map { |b| b.start_time..b.end_time }

    date_ranges.each do |range|
      if (range.include?(org_booking.start_time) || range.include?(org_booking.end_time))
        return false
      end
      return true
    end
  end

  def find_accepted_booking
    @agent_booking = AdBooking.find(params[:id])
    @accepted_booking = @agent_booking.org_bookings.where(status: 'accepted').take
  end

end