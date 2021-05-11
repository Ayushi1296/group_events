# frozen_string_literal: true
class GroupEvent
  module StateManagement
    extend ActiveSupport::Concern

    included do
      # AASM initialization
      aasm column: :status, whiny_transitions: false do #no_direct_assignment: true, whiny_transitions: false do
        state :draft, initial: true
        state :published

        event :publish do
          error { |e| logger.error("AASM error on GroupEvent of id: #{id}, event publish failed:\n#{e}") }
          transitions from: :draft,
                      to: :published,
                      guard: :can_be_published?
        end
      end
    end

    private

    def can_be_published?
      if deleted
        errors.add(:base, 'deleted event cannot be published')
        return false
      end

      attributes.each do |attr, value|
        errors.add(attr.to_sym, "can't be blank") if value.nil?
      end
      errors.empty?
    end
  end
end
