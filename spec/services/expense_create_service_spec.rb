require 'rails_helper'

RSpec.describe ExpenseCreateService do
  describe '#call' do
    context 'when the user is an employee' do
      let(:user) { create(:user, :employee) }
      let(:amount) { 123 }
      let(:description) { "New expense description" }
      let(:params) { { amount: amount, description: description } }

      it 'creates a drafted expense' do
        result = ExpenseCreateService.new(user, params).call
        expect(result[:success]).to eq(true)
        expect(result[:data].amount).to eq(amount)
        expect(result[:data].description).to eq(description)
        expect(result[:data].state).to eq("drafted")
      end
    end

    context 'when the user is not an employee' do
      let(:user) { create(:user, :reviewer) }
      let(:amount) { 123 }
      let(:description) { "New expense description" }
      let(:params) { { amount: amount, description: description } }

      it 'returns an error' do
        result = ExpenseCreateService.new(user, params).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:forbidden)
      end
    end

    context 'when the user is not found' do
      let(:user) { nil }
      let(:amount) { 123 }
      let(:description) { "New expense description" }
      let(:params) { { amount: amount, description: description } }

      it 'returns an error' do
        result = ExpenseCreateService.new(user, params).call
        expect(result[:success]).to eq(false)
        expect(result[:type]).to eq(:not_found)
      end
    end

    context 'when submit is true' do
      let(:user) { create(:user, :employee) }
      let(:amount) { 123 }
      let(:description) { "New expense description" }
      let(:params) { { amount: amount, description: description, submit: true } }

      it 'creates a submitted expense' do
        result = ExpenseCreateService.new(user, params).call
        expect(result[:success]).to eq(true)
        expect(result[:data].amount).to eq(amount)
        expect(result[:data].description).to eq(description)
        expect(result[:data].state).to eq("submitted")
      end
    end
  end
end
