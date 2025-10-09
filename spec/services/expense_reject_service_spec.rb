require 'rails_helper'

RSpec.describe ExpenseRejectService do
  let(:employee) { create(:user, :employee) }
  let(:reviewer) { create(:user, :reviewer) }
  let(:expense) { create(:expense, :submitted) }

  describe '#call' do
    context 'when user is a reviewer' do
      it 'rejects the expense' do
        result = ExpenseRejectService.new(reviewer, { id: expense.id }).call
        expect(result[:success]).to eq(true)
        expect(expense.reload.state).to eq("rejected")
        expect(expense.reload.reviewed_at).to be_present
      end
    end

    context 'when user is not a reviewer' do
      it 'returns an error' do
        result = ExpenseRejectService.new(employee, { id: expense.id }).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:forbidden)
      end
    end

    context 'when expense is not in a submitted state' do
      let(:expense) { create(:expense, :drafted) }
      it 'returns an error' do
        result = ExpenseRejectService.new(reviewer, { id: expense.id }).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:forbidden)
      end
    end
  end
end
