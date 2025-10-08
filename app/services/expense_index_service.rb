class ExpenseIndexService < BaseService
  def initialize(user)
    @user = user
  end

  def call
    return error(message: "User not found", type: :not_found) unless @user

    @expenses = fetch_expenses

    success(message: "Expenses fetched successfully", data: @expenses)
  end

  private

  def fetch_expenses
    if @user.employee?
      @user.expenses
    elsif @user.reviewer?
      Expense.includes(:employee).for_reviewer
    end
  end
end
