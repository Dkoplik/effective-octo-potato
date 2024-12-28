class LobbyChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug "someone connected - ID: #{self.id}"
  end

  def unsubscribed
    Rails.logger.debug "someone disconnected"
  end
end
