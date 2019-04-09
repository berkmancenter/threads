# frozen_string_literal: true
class RoomsController < ApplicationController
  before_action :load_rooms, only: %i[index show simple]
  before_action :load_room, only: %i[show edit update destroy simple]

  def index; end

  def show
    @instance = @room.instance

    authorize! :read, @room

    @message = Message.new
    @messages = @room.messages.order(:created_at)
    RoomUser.create_or_update!(@room.id, current_or_guest_user.id, @messages&.last&.id)
  end

  def new
    @instance = Instance.find(params[:id])

    authorize! :create_room_in, @instance

    @room = Room.new
  end

  def create
    @instance = Instance.find(room_params[:instance_id])

    authorize! :create_room_in, @instance

    @room = Room.new(room_params.merge(owner_id: current_or_guest_user.id))
    if @room.save
      RoomUser.create_or_update!(@room.id, current_or_guest_user.id, nil)
      redirect_to instance_url(@instance, access_token: params[:access_token].present? ? params[:access_token]:nil), notice: 'Thread has been created successfully'
    else
      flash.now[:alert] = @room.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    authorize! :update, @room
  end

  def update
    authorize! :update, @room

    if @room.update_attributes(room_params)
      redirect_to rooms_url, notice: 'Thread has been updated successfully'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @room

    @room.destroy
    redirect_to rooms_url, notice: 'Thread has been deleted successfully'
  end

  def simple
    authorize! :read, @room

    RoomUser.create_or_update!(@room.id, current_or_guest_user.id, @room.messages&.last&.id)

    render @rooms
  end

  def lock
    @room = Room.find(params[:id])

    authorize! :update, @room

    if @room.update_attributes(locked: true)
      redirect_to request.referer, notice: 'Thread has been locked'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def unlock
    @room = Room.find(params[:id])

    authorize! :update, @room

    if @room.update_attributes(locked: false)
      redirect_to request.referer, notice: 'Thread has been unlocked'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  private

  def room_params
    params.require(:room).permit(:title, :instance_id)
  end

  def load_rooms
    @room = Room.find(params[:id] || params[:room_id])
    @rooms = @room.instance.rooms_sorted_by_last_message
  end

  def load_room
    @room = Room.find(params[:id])
  end
end
