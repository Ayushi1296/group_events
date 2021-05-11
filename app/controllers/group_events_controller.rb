class GroupEventsController < ApplicationController
  before_action :set_group_event, only: [:show, :update, :destroy, :publish]

  def index
    data = { group_events: GroupEvent.not_deleted }
    success_response(data)
  end

  def show
    data = { group_event: @group_event }
    success_response(data)
  end

  def create
    group_event = GroupEvents::CreateEvent.run(create_params)
    if group_event.valid?
      data = { group_event: group_event.result }
      success_response(data)
    else
      error_response(group_event.errors.messages)
    end
  end

  def update
    outcome = GroupEvents::UpdateEvent.run(update_params.merge(group_event: @group_event))
    if outcome.valid?
      data = { group_event: @group_event }
      success_response(data)
    else
      error_response(outcome.errors.messages)
    end
  end

  def destroy
    @group_event.update(deleted: true)
    data = { group_event: @group_event }
    success_response(data)
  end

  def publish
    if @group_event.publish!
      data = { group_event: @group_event }
      success_response(data)
    else
      error_response(@group_event.errors.messages)
    end
  end

  private

  def set_group_event
    @group_event = GroupEvent.find_by_id(params[:id])
    error_response("GroupEvent #{params[:id]} not found.", 404) unless @group_event
  end

  def create_params
    params.require(:group_event).permit(:name, :description, :address, :city, :state, :country, :zipcode, :start_date, :end_date, :duration, :user_id)
  end

  def update_params
    params.require(:group_event).permit(:name, :description, :address, :city, :state, :country, :zipcode, :start_date, :end_date, :duration)
  end
end
