require 'rails_helper'

RSpec.describe ExpenseApproveService do
  let(:employee) { create(:user, :employee) }
  let(:reviewer) { create(:user, :reviewer) }
  let(:expense) { create(:expense, :submitted) }

  describe '#call' do
    context 'when user is a reviewer' do
      it 'approves the expense' do
        result = ExpenseApproveService.new(reviewer, {id: expense.id}).call
        expect(result[:success]).to eq(true)
        expect(expense.reload.state).to eq("approved")
        expect(expense.reload.reviewed_at).to be_present
      end
    end

    context 'when user is not a reviewer' do
      it 'returns an error' do
        result = ExpenseApproveService.new(employee, {id: expense.id}).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:unprocessable_entity)
      end
    end

    context 'when expense is not in a submitted state' do
      let(:expense) { create(:expense, :drafted) }
      it 'returns an error' do
        result = ExpenseApproveService.new(reviewer, {id: expense.id}).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:unprocessable_entity)
      end
    end
  end
end
