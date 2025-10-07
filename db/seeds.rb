# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = [
  { name: "Employee 1", email: "employee1@example.com", role: "employee" },
  { name: "Employee 2", email: "employee2@example.com", role: "employee" },
  { name: "Reviewer 1", email: "reviewer1@example.com", role: "reviewer" },
  { name: "Reviewer 2", email: "reviewer2@example.com", role: "reviewer" },
]

users.each do |user_data|
  User.find_or_create_by!(user_data)
end

expenses = [
  { amount: 100, description: "Expense 1", employee_id: User.employee.first.id, state: "drafted" },
  { amount: 200, description: "Expense 2", employee_id: User.employee.last.id, state: "drafted" },
  { amount: 300, description: "Expense 3", employee_id: User.employee.first.id, state: "submitted",
    submitted_at: Time.current },
  { amount: 400, description: "Expense 4", employee_id: User.employee.last.id, state: "submitted",
    submitted_at: Time.current },
  { amount: 500, description: "Expense 5", employee_id: User.employee.first.id, state: "approved",
    reviewer_id: User.reviewer.first.id, reviewed_at: Time.current },
  { amount: 600, description: "Expense 6", employee_id: User.employee.last.id, state: "approved",
    reviewer_id: User.reviewer.last.id, reviewed_at: Time.current },
  { amount: 700, description: "Expense 7", employee_id: User.employee.first.id, state: "rejected",
    reviewer_id: User.reviewer.first.id, reviewed_at: Time.current },
  { amount: 800, description: "Expense 8", employee_id: User.employee.last.id, state: "rejected",
    reviewer_id: User.reviewer.last.id, reviewed_at: Time.current },
]

expenses.each do |expense_data|
  Expense.find_or_create_by!(expense_data)
end
