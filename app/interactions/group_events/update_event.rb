module GroupEvents
  class UpdateEvent < ActiveInteraction::Base
    object   :group_event, class: 'GroupEvent'

    string   :name, default: -> { group_event.name }
    string   :description, default: -> { group_event.description }
    string   :address, default: -> { group_event.address }
    string   :city, default: -> { group_event.city }
    string   :state, default: -> { group_event.state }
    string   :country, default: -> { group_event.country }
    string   :zipcode, default: -> { group_event.zipcode }
    date     :start_date, default: -> { group_event.start_date }
    date     :end_date, default: -> { group_event.end_date }
    integer  :duration, default: -> { group_event.duration }

    def execute
      group_event.update!(params)

      group_event
    rescue ActiveRecord::RecordInvalid => e
      group_event.errors.messages
    rescue ActiveInteraction::InvalidInteractionError => e
      group_event.errors.messages.merge({ create: e.message })
    end

    private

    def params
      inputs.except(:group_event)
    end
  end
end
