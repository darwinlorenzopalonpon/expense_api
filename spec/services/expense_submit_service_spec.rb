require 'rails_helper'

RSpec.describe ExpenseSubmitService do
  describe '#call' do
    context 'when user is employee' do
      let(:user) { create(:user, :employee) }
      let(:expense) { create(:expense, employee: user) }

      it 'submits the expense' do
        result = ExpenseSubmitService.new(user, {id: expense.id}).call
        expect(result[:success]).to eq(true)
      end
    end

    context 'when expense is not in a draft state' do
      let(:user) { create(:user, :reviewer) }
      let(:expense) { create(:expense, :submitted, employee: user) }

      it 'returns an error' do
        result = ExpenseSubmitService.new(user, {id: expense.id}).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:unprocessable_entity)
      end
    end

    context 'when expense does not belong to the user' do
      let(:user) { create(:user, :employee) }
      let(:expense) { create(:expense) }

      it 'returns an error' do
        result = ExpenseSubmitService.new(user, {id: expense.id}).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:unprocessable_entity)
      end
    end

    context 'when expense is not found' do
      let(:user) { create(:user, :employee) }
      let(:expense) { nil }

      it 'returns an error' do
        result = ExpenseSubmitService.new(user, {id: expense&.id}).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:not_found)
      end
    end
  end
end
