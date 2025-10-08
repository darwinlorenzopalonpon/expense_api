class Expense < ApplicationRecord
  include AASM

  belongs_to :employee, class_name: "User"
  belongs_to :reviewer, class_name: "User", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :employee, presence: true
  validates :state, inclusion: { in: %w[drafted submitted approved rejected] }
  validates :submitted_at, presence: true, if: :submitted?
  validates :reviewed_at, presence: true, if: :reviewed?

  aasm column: :state do
    state :drafted, initial: true
    state :submitted
    state :approved
    state :rejected

    event :submit do
      transitions from: :drafted, to: :submitted
      before do
        self.submitted_at = Time.current
      end
    end

    event :approve do
      transitions from: :submitted, to: :approved
      before do
        self.reviewed_at = Time.current
      end
    end

    event :reject do
      transitions from: :submitted, to: :rejected
      before do
        self.reviewed_at = Time.current
      end
    end
  end

  def submitted?
    state == "submitted"
  end

  def reviewed?
    state == "approved" || state == "rejected"
  end
end
