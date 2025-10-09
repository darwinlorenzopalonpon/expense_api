class ExpenseSubmitService < BaseService
  def initialize(user, params)
    @user = user
    @expense = Expense.find_by(id: params[:id])
  end

  def call
    return error(message: "Expense not found", type: :not_found) unless @expense
    return error(message: "Expense is not in a draft state", type: :forbidden) unless @expense.drafted?
    return error(message: "Expense does not belong to the user", type: :forbidden) unless @expense.employee == @user

    begin
      @expense.submit!
      success(message: "Expense submitted successfully", data: @expense)
    rescue => e
      error(message: "Failed to submit expense: #{e.message}", type: :unprocessable_entity)
    end
  end
end
