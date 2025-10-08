require 'rails_helper'

RSpec.describe ExpenseIndexService do
  describe '#call' do
    context 'when user is an employee' do
      let(:user) { create(:user, :employee) }
      let(:expense) { create(:expense, employee: user) }

      it 'returns expenses for employee' do
        result = ExpenseIndexService.new(user).call
        expect(result[:success]).to eq(true)
        expect(result[:data]).to include(expense)
      end
    end

    context 'when user is a reviewer' do
      let(:user) { create(:user, :reviewer) }
      let(:expense) { create(:expense, :submitted) }

      it 'returns expenses for reviewer' do
        result = ExpenseIndexService.new(user).call
        expect(result[:data]).to include(expense)
      end
    end

    context 'when user is not found' do
      let(:user) { nil }

      it 'returns an error' do
        result = ExpenseIndexService.new(user).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:not_found)
      end
    end
  end
end
