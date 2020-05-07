class OrgBookingsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_user_type

  def index
  	ad_booking_ids = OrgBooking.where(user_id: current_user.id).where("end_time >= ?", DateTime.now).pluck(:ad_booking_id)
  	@agent_bookings = AdBooking.where.not(id: ad_booking_ids).where(status: 'vacant')
  end

  def new
  	@ad_booking = AdBooking.find(params[:ad_booking_id])
  	@org_booking = OrgBooking.new
  end

  def create
  	@org_booking = OrgBooking.new(org_booking_params)

  	if @org_booking.save
      OrganisationMailer.delay.slot_bidding_mail(@org_booking.slot_id, current_user)
  		redirect_to org_bookings_path, notice: 'Pre Booked Slot was successfully created. You will be notified once Agent accepts the offer'
  	else
  		render :new
  	end
  end

  def edit
    @org_booking = OrgBooking.find(params[:id])
    @ad_booking = AdBooking.find(@org_booking.ad_booking_id)
  end

  def update
    @org_booking = OrgBooking.find(params[:id])
    if @org_booking.update(org_booking_params)
      redirect_to org_bookings_path, notice: 'Pre Booked Slot was successfully updated. You will be notified once Agent accepts the offer'
    else
      render :edit
    end
  end

  def pending_request
    @pending_requests = OrgBooking.where(user_id: current_user.id, status: 'pending')
  end

  def accepted_request
    @accepted_requests = OrgBooking.where(user_id: current_user.id, status: 'accepted')
  end

  def rejected_request
    @rejected_requests = OrgBooking.where(user_id: current_user.id, status: 'rejected')
  end

  def previously_booked
    @previously_booked_slots = OrgBooking.where(user_id: current_user.id, status: ['accepted', 'expired'])
  end

  private

  def org_booking_params
    params.require(:org_booking).permit(:start_time, :end_time, :slot_id, :user_id, :ad_booking_id, :rent_amount, :status)
  end

  def authenticate_user_type
    unless current_user.organisations?
      redirect_to root_path, alert: 'Access denied. You are not ad organisations'
    end
  end

end
