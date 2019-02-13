# frozen_string_literal: true
class InstancesController < ApplicationController
  def index
    @instances = Instance.where(private: false)
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
      redirect_to instances_url, notice: 'Instance is updated successfully'
    else
      render :edit
    end
  end

  private

  def instance_params
    params.require(:instance).permit(:title, :closed, :private)
  end
end
