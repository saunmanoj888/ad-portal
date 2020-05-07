class AgentMailer < ApplicationMailer

  def slot_booking_mail agent_booking, agent
    @agent = agent
    @agent_booking = agent_booking
    if @agent.present?
      mail to: @agent.email, message: "You have pre booked a new Slot"
    end
  end
end