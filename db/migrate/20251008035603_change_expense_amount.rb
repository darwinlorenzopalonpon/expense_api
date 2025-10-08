class ChangeExpenseAmount < ActiveRecord::Migration[8.0]
  def up
    change_column :expenses, :amount, :integer
  end

  def down
    change_column :expenses, :amount, :decimal
  end
end
