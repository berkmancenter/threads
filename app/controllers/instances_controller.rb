# frozen_string_literal: true
class InstancesController < ApplicationController
  before_action :load_instance, except: %i[index new create]

  def index
    @instances = Instance.all_for_user(current_or_guest_user)
  end

  def show
    authorize! :read, @instance
  end

  def new
    authorize! :create, Instance

    @instance = Instance.new
  end

  def create
    authorize! :create, Instance

    @instance = Instance.new(instance_params.merge(owner_id: current_or_guest_user.id))
    if @instance.save
      redirect_to instances_url, notice: 'Instance is created successfully'
    else
      render :new
    end
  end

  def edit
    authorize! :update, @instance
  end

  def update
    authorize! :update, @instance

    if @instance.update_attributes(instance_params)
      redirect_to instances_url, notice: 'Topic has been updated successfully'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @instance

    @instance.destroy
    redirect_to instances_url, notice: 'Topic has been deleted successfully'
  end

  def close
    authorize! :toggle_open_topic, @instance

    if @instance.update_attributes(closed: true)
      redirect_to request.referer, notice: 'Topic has been closed'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def open
    authorize! :toggle_open_topic, @instance

    if @instance.update_attributes(closed: false)
      redirect_to request.referer, notice: 'Topic has been opened'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def private
    authorize! :update, @instance

    if @instance.update_attributes(private: true)
      redirect_to request.referer, notice: 'Topic has been set as private'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def unprivate
    authorize! :update, @instance

    if @instance.update_attributes(private: false)
      redirect_to request.referer, notice: 'Topic has been set as not private'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def set_moderators
    authorize! :set_moderators, @instance

    users = User.where(id: params[:instance][:moderators])
    users.each do |user|
      unless user.role? Role.moderator
        user.roles << Role.moderator
        user.save!
      end
    end

    if @instance.update_attributes(moderators: User.where(id: params[:instance][:moderators]))
      redirect_to request.referer, notice: 'Moderators have been set'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def export
    content = ''

    content += @instance.title

    @instance.rooms_sorted_by_last_message.each do |room|
      latest_message_date = room.messages
                                .order(:created_at)
                                .last
                                &.created_at
                                &.to_formatted_s(:long_ordinal)

      content += "#{room.title} "
      content += "(#{room.messages.count} replies"
      content += " / last update #{latest_message_date}" if latest_message_date
      content += ")\n"

      room.messages.order(:created_at).each do |message|
        message_content = message.content.delete("\r\n\\")
        content += "#{message.user.nickname_in_room(room)}: #{message_content}"
        content += "\n"
      end

      content += "\n"
    end

    filename = @instance.title.tr(' ', '_')
    send_data content,
              type: 'text',
              disposition: "attachment; filename=#{filename}_export.txt"
  end

  private

  def instance_params
    params.require(:instance).permit(:title, :closed, :private, :moderators)
  end

  def load_instance
    @instance = Instance.find(params[:id])
  end
end
