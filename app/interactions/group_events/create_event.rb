module GroupEvents
  class CreateEvent < ActiveInteraction::Base
    integer  :user_id
    string   :name
    string   :description, default: nil
    string   :address, default: nil
    string   :city, default: nil
    string   :state, default: nil
    string   :country, default: nil
    string   :zipcode, default: nil
    date     :start_date, default: nil
    date     :end_date, default: nil
    integer  :duration, default: nil

    def execute
      group_event = GroupEvent.new(inputs)
      group_event.save

      group_event
    end
  end
end
