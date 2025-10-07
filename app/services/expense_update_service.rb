class ExpenseUpdateService
  def initialize(user, params)
    @expense = Expense.find_by(id: params[:id])
    @user = user
    @amount = params[:amount]
    @description = params[:description]
  end

  def call
    return { success: false, error: "Expense does not belong to the user" } unless @expense.employee == @user

    begin
      @expense.update!(amount: @amount, description: @description)
      { success: true, message: "Expense updated successfully", expense: @expense }
    rescue => e
      { success: false, error: "Failed to update expense: #{e.message}" }
    end
  end
end
