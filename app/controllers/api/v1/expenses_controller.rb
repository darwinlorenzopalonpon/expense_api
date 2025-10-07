class Api::V1::ExpensesController < ApplicationController
  before_action :set_current_user

  def index
    @expenses = @current_user.expenses.all
    render json: @expenses
  end

  def show
    render json: @expense
  end

  def update
    result = ExpenseUpdateService.new(@current_user, update_params).call
    if result[:success]
      render json: result[:expense]
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def create
    @expense = @current_user.expenses.create!(create_params)
    # TODO: handle submit if params[:submit] is true
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
    params.require(:expense).permit(:id, :amount, :description)
  end

  def create_params
    params.require(:expense).permit(:amount, :description)
  end
end
