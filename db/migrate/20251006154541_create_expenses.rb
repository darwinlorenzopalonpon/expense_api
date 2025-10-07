class CreateExpenses < ActiveRecord::Migration[8.0]
  def up
    create_enum :expense_state, [:drafted, :submitted, :approved, :rejected]
    create_table :expenses do |t|
      t.decimal :amount, null: false
      t.string :description, null: false
      t.references :employee, null: false, foreign_key: { to_table: :users }
      t.references :reviewer, foreign_key: { to_table: :users }
      t.enum :state, enum_type: :expense_state, default: :drafted, null: false
      t.timestamp :submitted_at
      t.timestamp :reviewed_at

      t.timestamps
    end
  end

  def down
    drop_table :expenses
    drop_enum :expense_state
  end
end
