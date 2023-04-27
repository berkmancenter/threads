# frozen_string_literal: true
require 'sidekiq/api'

class RoomsController < ApplicationController
  before_action :load_rooms, only: %i[index show simple messages]
  before_action :load_room, except: %i[new create]

  def index; end

  def show
    @instance = @room.instance

    authorize! :read, @room

    @message = Message.new
    @messages = room_messages

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

    instance = @room.instance

    @room.destroy

    redirect_to instance, notice: 'Thread has been deleted successfully'
  end

  def simple
    authorize! :read, @room

    RoomUser.create_or_update!(@room.id, current_or_guest_user.id, @room.messages&.last&.id)

    render @rooms
  end

  def lock
    authorize! :update, @room

    if @room.update_attributes(locked: true)
      redirect_to request.referer, notice: 'Thread has been locked'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def unlock
    authorize! :update, @room

    if @room.update_attributes(locked: false)
      redirect_to request.referer, notice: 'Thread has been unlocked'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def set_delayed_lock
    authorize! :update, @room

    if @room.locked
      redirect_to request.referer,
                  notice: 'Can\'t set a delayed lock on a locked thread'
      return
    end

    lock_date = Time.now +
                params[:days].to_i.days +
                params[:hours].to_i.hours +
                params[:minutes].to_i.minutes

    @room.update_attributes!(planned_lock: lock_date)

    # Cleaning exisiting jobs
    queue_jobs = Sidekiq::ScheduledSet.new
    queue_jobs.each do |queue_job|
      if queue_job.klass == 'DelayedRoomLockWorker' && queue_job.args == [@room.id]
        queue_job.delete
      end
    end

    DelayedRoomLockWorker.perform_at(lock_date, @room.id)

    redirect_to request.referer, notice: 'Thread will be locked on ' + lock_date.to_formatted_s(:long_ordinal)
  end

  def cancel_delayed_lock
    @room.update_attributes!(planned_lock: nil)

    # Cleaning exisiting jobs
    queue_jobs = Sidekiq::ScheduledSet.new
    queue_jobs.each do |queue_job|
      if queue_job.klass == 'DelayedRoomLockWorker' && queue_job.args == [@room.id]
        queue_job.delete
      end
    end

    redirect_to request.referer, notice: 'Successfully cancelled the delayed lock'
  end

  def mute_user
    @user = User.find(params[:user_id])

    MutedRoomUser.create!(room: @room, user: @user)

    ActionCable.server.broadcast(
      "room_#{@room.id}",
      action: 'muted_user',
      data: {
        muted_user_id: @user.id
      }
    )

    redirect_to request.referer, notice: @user.nickname_in_room(@room) + ' has been muted in this thread'
  end

  def unmute_user
    @user = User.find(params[:user_id])

    MutedRoomUser.where(room: @room, user: @user).destroy_all

    ActionCable.server.broadcast(
      "room_#{@room.id}",
      action: 'unmuted_user',
      data: {
        unmuted_user_id: @user.id
      }
    )

    redirect_to request.referer, notice: @user.nickname_in_room(@room) + ' has been unmuted in this thread'
  end

  def messages
    authorize! :read, @room

    render room_messages, locals: { room: @room }
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
    @room = Room.includes(:messages).find(params[:id])
  end

  def room_messages
    if can?(:update, @room)
      @room.messages.includes(:user).order(:created_at)
    else
      Message.not_muted(@room.id).order(:created_at)
    end
  end
end
