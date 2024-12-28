require_relative "../services/lobby_manager.rb"

class LobbiesController < ApplicationController
  def list_all
    lobbies = LobbyManager.get_all_lobbies
    render json: { message: lobbies }, status: :ok
  end

  def connect
    lobby_params = JSON.parse(request.body.read)
    lobby = LobbyManager.get_lobby(lobby_params[:id])
  end

  def disconnect
    lobby_params = JSON.parse(request.body.read)
    lobby = LobbyManager.get_lobby(lobby_params[:id])
  end
end
