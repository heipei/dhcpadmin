class RoomController < ApplicationController

  def index
    @rooms = Room.find :all
  end

  def edit
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params[:room])
    if @room.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def update
    @room = Room.find(params[:room][:id])

    if @room.update_attributes(params[:room])
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

end
