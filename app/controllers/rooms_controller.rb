# frozen_string_literal: true
class RoomsController < ApplicationController
  before_action :load_rooms, only: %i[index show simple]

  def index; end

  def show
    @room = Room.find(params[:id])

    authorize! :read, @room

    @message = Message.new
    @messages = @room.messages
    RoomUser.create_or_update!(@room.id, current_or_guest_user.id, @messages&.last&.id)
  end

  def new
    authorize! :create, Room

    @instance = Instance.find(params[:id])
    @room = Room.new
  end

  def create
    authorize! :create, Room

    @instance = Instance.find(room_params[:instance_id])
    @room = Room.new(room_params.merge(owner_id: current_or_guest_user.id))
    if @room.save
      RoomUser.create_or_update!(@room.id, current_or_guest_user.id, nil)
      redirect_to @instance, notice: 'Room is created successfully'
    else
      flash.now[:alert] = @room.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    @room = Room.find(params[:id])

    authorize! :update, @room
  end

  def update
    @room = Room.find(params[:id])

    authorize! :update, @room

    if @room.update_attributes(room_params)
      redirect_to rooms_url, notice: 'Room is updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @room = Room.find(params[:id])

    authorize! :destroy, @room

    @room.destroy
    redirect_to rooms_url, notice: 'Room is deleted successfully'
  end

  def simple
    @room = Room.find(params[:room_id])

    authorize! :read, @room

    RoomUser.create_or_update!(@room.id, current_or_guest_user.id, @room.messages&.last&.id)

    render @rooms
  end

  private

  def room_params
    params.require(:room).permit(:title, :instance_id)
  end

  def load_rooms
    @room = Room.find(params[:id] || params[:room_id])
    @rooms = @room.instance.rooms_sorted_by_last_message
  end
end
