class ExpenseDeleteService < BaseService
  def initialize(user, params)
    @user = user
    @expense = Expense.find_by(id: params[:id])
  end

  def call
    return error(message: "Expense not found", type: :not_found) unless @expense
    return error(message: "Expense does not belong to the user", type: :unprocessable_entity) unless @expense.employee == @user
    return error(message: "Expense is not in a draft state", type: :unprocessable_entity) unless @expense.drafted?

    begin
      @expense.destroy!
      success(message: "Expense deleted successfully", data: @expense)
    rescue => e
      error(message: "Failed to delete expense: #{e.message}", type: :unprocessable_entity)
    end
  end
end
