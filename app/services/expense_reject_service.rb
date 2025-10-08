class ExpenseRejectService < BaseService
  def initialize(user, params)
    @user = user
    @expense = Expense.find_by(id: params[:id])
  end

  def call
    return error(message: "Expense not found", type: :not_found) unless @expense
    return error(message: "Expense is not in a submitted state", type: :unprocessable_entity) unless @expense.submitted?
    return error(message: "User is not a reviewer", type: :unprocessable_entity) unless @user.reviewer?

    begin
      @expense.reviewer = @user
      @expense.reject!
      success(message: "Expense rejected successfully", data: @expense)
    rescue => e
      error(message: "Failed to reject expense: #{e.message}", type: :unprocessable_entity)
    end
  end
end
