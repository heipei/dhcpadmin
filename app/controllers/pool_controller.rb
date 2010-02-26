class PoolController < ApplicationController

  def index
    @machines = (Machine.find :all).select{|m| m.room.nil?}
  end
end
