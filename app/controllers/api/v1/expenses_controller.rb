class Api::V1::ExpensesController < ApplicationController
  before_action :set_current_user

  def index
    @expenses = Expense.includes(:employee, :reviewer).all
    render json: @expenses, each_serializer: Api::V1::ExpenseSerializer
    end

  def show
    @expense = Expense.find_by(id: params[:id])
    if @expense.nil?
      return render json: { error: "Expense not found" }, status: :not_found
    end
    render json: @expense, serializer: Api::V1::ExpenseSerializer
  end

  def destroy
    result = ExpenseDeleteService.new(@current_user, { id: params[:id] }).call
    render_service_response(result, serializer: Api::V1::ExpenseSerializer)
  end

  def update
    result = ExpenseUpdateService.new(@current_user, update_params).call
    render_service_response(result, serializer: Api::V1::ExpenseSerializer)
  end

  def create
    result = ExpenseCreateService.new(@current_user, create_params).call
    render_service_response(result, serializer: Api::V1::ExpenseSerializer)
  end

  def submit
    result = ExpenseSubmitService.new(@current_user, { id: params[:id] }).call
    render_service_response(result, serializer: Api::V1::ExpenseSerializer)
  end

  def approve
    result = ExpenseApproveService.new(@current_user, { id: params[:id] }).call
    render_service_response(result, serializer: Api::V1::ExpenseSerializer)
  end

  def reject
    result = ExpenseRejectService.new(@current_user, { id: params[:id] }).call
    render_service_response(result, serializer: Api::V1::ExpenseSerializer)
  end

  private

  def update_params
    params.require(:expense).permit(:amount, :description).merge(id: params[:id])
  end

  def create_params
    params.require(:expense).permit(:amount, :description, :submit)
  end
end
