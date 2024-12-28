class Lobby
  include ActiveModel::Model

  attr_accessor :id, :owner, :players

  def initialize(id, owner)
    @id = id
    @owner = owner
    @players = [ owner ]
  end

  def add_player(player)
    @players << player
  end

  def remove_player(player)
    @players.delete(player)
  end
end
