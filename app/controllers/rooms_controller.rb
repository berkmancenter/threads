# frozen_string_literal: true
class RoomsController < ApplicationController
  def index
    if user_signed_in?
      @rooms = Room.all
    else
      redirect_to login_path
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
    else
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(room_params)
    else
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
  end

  private

  def room_params
    params.require(:room).permit(:title)
  end
end
