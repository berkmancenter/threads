# frozen_string_literal: true
class InstancesController < ApplicationController
  def index
    @instances = Instance.all_for_user(current_or_guest_user)
  end

  def show
    @instance = Instance.find(params[:id])

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
    @instance = Instance.find(params[:id])

    authorize! :update, @instance
  end

  def update
    @instance = Instance.find(params[:id])

    authorize! :update, @instance

    if @instance.update_attributes(instance_params)
      redirect_to instances_url, notice: 'Topic has been updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @instance = Instance.find(params[:id])

    authorize! :destroy, @instance

    @instance.destroy
    redirect_to instances_url, notice: 'Topic has been deleted successfully'
  end

  def close
    @instance = Instance.find(params[:id])

    authorize! :toggle_open_topic, @instance

    if @instance.update_attributes(closed: true)
      redirect_to request.referer, notice: 'Topic has been closed'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def open
    @instance = Instance.find(params[:id])

    authorize! :toggle_open_topic, @instance

    if @instance.update_attributes(closed: false)
      redirect_to request.referer, notice: 'Topic has been opened'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def private
    @instance = Instance.find(params[:id])

    authorize! :update, @instance

    if @instance.update_attributes(private: true)
      redirect_to request.referer, notice: 'Topic has been set as private'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def unprivate
    @instance = Instance.find(params[:id])

    authorize! :update, @instance

    if @instance.update_attributes(private: false)
      redirect_to request.referer, notice: 'Topic has been set as not private'
    else
      redirect_to request.referer, notice: 'Something went wrong, try again'
    end
  end

  def set_moderators
    @instance = Instance.find(params[:id])

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

  private

  def instance_params
    params.require(:instance).permit(:title, :closed, :private, :moderators)
  end
end
