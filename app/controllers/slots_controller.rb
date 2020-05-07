class SlotsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :index]
	before_action :authenticate_user_type, only: [:new, :create, :index]

	def index
    @slots = Slot.all
	end

  def new
  	@slot = Slot.new
  end

  def create
  	@slot = Slot.new(slot_params)
  	@slot.user_id = current_user.id

  	if @slot.save
      ProviderMailer.delay.slot_creation_mail(@slot, current_user)
  		redirect_to slots_path, notice: 'Slot was successfully created.'
  	else
  		render :new
  	end
  end

  private

  def authenticate_user_type
  	unless current_user.ad_space_provider?
  		redirect_to root_path, alert: 'Access denied. You are not ad space provider'
  	end
  end


  def slot_params
    params.require(:slot).permit(:name)
  end

end
