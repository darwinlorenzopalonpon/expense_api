class CreateUsers < ActiveRecord::Migration[8.0]
  def up
    create_enum :user_role, [ :employee, :reviewer ]

    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.enum :role, enum_type: :user_role, default: :employee, null: false

      t.timestamps
    end
  end

  def down
    drop_table :users
    drop_enum :user_role
  end
end
