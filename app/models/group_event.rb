# frozen_string_literal: true
class GroupEvent < ApplicationRecord
  include AASM
  include GroupEvent::StateManagement

  # Associations
  belongs_to :user

  # Callbacks
  before_validation :set_dates_and_duration
  before_validation :set_status_to_draft, on: :create

  # Validations
  validates_presence_of :name, :status, allow_blank: false
  validates_uniqueness_of :name, { case_sensitive: false }
  validates_numericality_of :duration, greater_than_or_equal_to: 0, allow_nil: true
  validates_numericality_of :zipcode, only_integer: true, allow_nil: true
  validate :check_valid_start_and_end_dates

  scope :deleted, -> { where(deleted: true) }
  scope :not_deleted, -> { where(deleted: false) }

  enum status: { draft: 'Draft', published: 'Published' }

  private

  def set_status_to_draft
    self.status ||= :draft
  end

  def set_dates_and_duration
    return unless start_date_changed? || end_date_changed? || duration_changed?

    if (start_date_changed? || end_date_changed?) && start_date.present? && end_date.present?
      self.duration = (end_date - start_date).to_i
    elsif (start_date_changed? || duration_changed?) && start_date.present? && duration.present?
      self.end_date = start_date + duration
    elsif (end_date_changed? || duration_changed?) && duration.present? && end_date.present?
      self.start_date = end_date - duration
    end
  end

  def check_valid_start_and_end_dates
    return unless start_date && end_date && duration

    if end_date < start_date
      errors.add(:end_date, 'should be greater than the start_date')
    elsif start_date + duration != end_date
      errors.add(:duration, 'should be the exact difference b/w start and end dates')
    end
  end
end
