require 'rails_helper'

RSpec.describe ExpenseUpdateService do
  describe '#call' do
    context 'when the user is the employee of the expense' do
      let(:user) { create(:user, :employee) }
      let(:expense) { create(:expense, employee: user) }
      let(:amount) { 123 }
      let(:description) { "Updated description" }
      let(:params) { { id: expense.id, amount: amount, description: description } }

      it 'updates an expense' do
        result = ExpenseUpdateService.new(user, params).call
        expect(result[:success]).to be_truthy
        expect(result[:expense].amount).to eq(amount)
        expect(result[:expense].description).to eq(description)
      end
    end

    context 'when the user is not the employee of the expense' do
      let(:user) { create(:user, :employee) }
      let(:expense) { create(:expense) }
      let(:amount) { 123 }
      let(:description) { "Updated description" }
      let(:params) { { id: expense.id, amount: amount, description: description } }

      it 'returns an error' do
        result = ExpenseUpdateService.new(user, params).call
        expect(result[:success]).to be_falsey
      end
    end
  end
end
