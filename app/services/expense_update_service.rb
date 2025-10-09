class ExpenseUpdateService < BaseService
  def initialize(user, params)
    @expense = Expense.find_by(id: params[:id])
    @user = user
    @amount = params[:amount]
    @description = params[:description]
  end

  def call
    return error(message: "Expense not found", type: :not_found) unless @expense
    return error(message: "User not found", type: :not_found) unless @user
    return error(message: "Expense is not in a draft state", type: :forbidden) unless @expense.drafted?
    return error(message: "Expense does not belong to the user", type: :forbidden) unless @expense.employee == @user
    return error(message: "Amount is required", type: :bad_request) unless @amount.present?
    return error(message: "Description is required", type: :bad_request) unless @description.present?

    begin
      @expense.update!(amount: @amount, description: @description)
      success(message: "Expense updated successfully", data: @expense)
    rescue => e
      error(message: "Failed to update expense: #{e.message}", type: :unprocessable_entity)
    end
  end
end
