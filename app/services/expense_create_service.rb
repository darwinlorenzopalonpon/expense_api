class ExpenseCreateService < BaseService
  def initialize(user, params)
    @user = user
    @submit = params[:submit] == "true" || params[:submit] == true
    @amount = params[:amount]
    @description = params[:description]
  end

  def call
    return error(message: "User not found", type: :not_found) unless @user
    return error(message: "User is not an employee", type: :forbidden) unless @user.employee?
    return error(message: "Amount is required", type: :bad_request) unless @amount.present?
    return error(message: "Description is required", type: :bad_request) unless @description.present?

    @expense = @user.expenses.build(amount: @amount, description: @description)

    begin
      # check if expense is for immediate submission
      if @submit
        @expense.state = :submitted
        @expense.submitted_at = Time.current
      end

      @expense.save!

      message = @submit ? "Expense created and submitted successfully" : "Expense created successfully"
      success(message: message, data: @expense)
    rescue => e
      error(message: "Failed to create expense: #{e.message}", type: :unprocessable_entity)
    end
  end
end
