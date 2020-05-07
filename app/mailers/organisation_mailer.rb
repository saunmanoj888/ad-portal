class OrganisationMailer < ApplicationMailer

  def slot_bidding_mail slot_id, org
    @org = org
    @slot = Slot.find(slot_id)
    if @org.present?
      mail to: @org.email, message: "You have bid for the Slot"
    end
  end

  def bid_confirmation_mail user_id, slot_id
    @org = User.find(user_id)
    @slot = Slot.find(slot_id)
    if @org.present?
      mail to: @org.email, message: "Your  bid has been accepted"
    end
  end

  def bid_rejection_mail user_id, slot_id
    @org = User.find(user_id)
    @slot = Slot.find(slot_id)
    if @org.present?
      mail to: @org.email, message: "Your  bid has been rejected"
    end
  end

  def date_change_mail user_id, slot_id
    @org = User.find(user_id)
    @slot = Slot.find(slot_id)
    if @org.present?
      mail to: @org.email, message: "Your  bid dates need to be changed"
    end
  end

end