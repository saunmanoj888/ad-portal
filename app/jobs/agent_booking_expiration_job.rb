class AgentBookingExpirationJob < ApplicationJob
  queue_as :default

  def perform(agent_booking)
    agent_booking.update_attribute(:status, 'vacant')
  end
end
