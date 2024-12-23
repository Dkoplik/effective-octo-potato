class LobbyChannel < ApplicationCable::Channel
  def subscribed
    puts "someone connected"
  end

  def unsubscribed
    puts "someone disconnected"
  end
end
