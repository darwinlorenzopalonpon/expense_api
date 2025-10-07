class Api::V1::ExpensesController < ApplicationController
  before_action :set_current_user
  before_action :set_expense, only: [ :show, :submit, :approve, :reject ]

  def index
    @expenses = @current_user.expenses.all
    render json: @expenses
  end

  def show
    render json: @expense
  end

  def update
    # TODO: Implement update
  end

  def create
    @expense = @current_user.expenses.create!(expense_params)
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

  def set_expense
    @expense = Expense.find(params[:id])
  end
end
