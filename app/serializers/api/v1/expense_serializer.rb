class Api::V1::ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :state, :submitted_at, :reviewed_at

  belongs_to :employee, serializer: Api::V1::UserSerializer
  belongs_to :reviewer, serializer: Api::V1::UserSerializer
end
