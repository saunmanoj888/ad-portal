class PublicController < ApplicationController

  def main
    if user_signed_in?
      redirect_to user_path, flash: { success: "Successfully logged in" } and return
    end
  end

  private

  def user_path
    if current_user.ad_space_provider?
      slots_path
    elsif current_user.ad_space_agent?
      vacant_slots_path
    else
      org_bookings_path
    end
  end

end