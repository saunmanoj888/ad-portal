module SlotsHelper

  def slot_creater_name slot
    if slot.user == current_user
      'You'
    else
      slot.user.full_name
    end
  end
end
