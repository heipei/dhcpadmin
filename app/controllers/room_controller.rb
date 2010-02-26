class RoomController < ApplicationController

  def index
    @rooms = Room.find :all
  end


end
