class Api::V1::ExpensesController < ApplicationController
  before_action :set_current_user

  def index
    @expenses = @current_user.expenses
    render json: @expenses
  end

  def show
    @expense = @current_user.expenses.find_by(id: params[:id])
    if @expense.nil?
      return render json: { error: "Expense not found" }, status: :not_found
    end
    render json: @expense
  end

  def update
    result = ExpenseUpdateService.new(@current_user, update_params).call
    render_service_response(result)
  end

  def create
    result = ExpenseCreateService.new(@current_user, create_params).call
    render_service_response(result)
  end

  def submit
    # TODO: Implement submit
  end

  def approve
    # TODO: Implement approve
  end

  def reject
    # TODO: Implement reject
  end

  private

  def update_params
    params.require(:expense).permit(:amount, :description).merge(id: params[:id])
  end

  def create_params
    params.require(:expense).permit(:amount, :description, :submit)
  end
end
