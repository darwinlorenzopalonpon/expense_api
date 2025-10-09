require 'rails_helper'

RSpec.describe ExpenseDeleteService do
  let(:employee) { create(:user, :employee) }
  let(:expense) { create(:expense, :drafted, employee: employee) }

  describe '#call' do
    context 'when user is the employee' do
      it 'destroys the expense' do
        result = ExpenseDeleteService.new(employee, { id: expense.id }).call
        expect(result[:success]).to eq(true)
      end
    end

    context 'when user is not the employee' do
      let(:user) { create(:user, :reviewer) }
      it 'returns an error' do
        result = ExpenseDeleteService.new(user, { id: expense.id }).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:forbidden)
      end
    end

    context 'when expense is not in a draft state' do
      let(:expense) { create(:expense, :submitted, employee: employee) }
      it 'returns an error' do
        result = ExpenseDeleteService.new(employee, { id: expense.id }).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:forbidden)
      end
    end

    context 'when expense is not found' do
      let(:expense) { nil }
      it 'returns an error' do
        result = ExpenseDeleteService.new(employee, { id: expense&.id }).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:not_found)
      end
    end
  end
end
