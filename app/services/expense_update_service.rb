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
    return error(message: "Expense does not belong to the user", type: :unprocessable_entity) unless @expense.employee == @user

    begin
      @expense.update!(amount: @amount, description: @description)
      success(message: "Expense updated successfully", data: @expense)
    rescue => e
      error(message: "Failed to update expense: #{e.message}", type: :unprocessable_entity)
    end
  end
end
