class User < ApplicationRecord
  has_many :expenses, foreign_key: :employee_id, dependent: :destroy
  has_many :reviewed_expenses, class_name: "Expense", foreign_key: :reviewer_id, dependent: :nullify

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, inclusion: { in: %w[employee reviewer] }

  scope :employee, -> { where(role: "employee") }
  scope :reviewer, -> { where(role: "reviewer") }

  def employee?
    role == "employee"
  end

  def reviewer?
    role == "reviewer"
  end
end
