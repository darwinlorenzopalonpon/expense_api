# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_08_035603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "expense_state", ["drafted", "submitted", "approved", "rejected"]
  create_enum "user_role", ["employee", "reviewer"]

  create_table "expenses", force: :cascade do |t|
    t.integer "amount", null: false
    t.string "description", null: false
    t.bigint "employee_id", null: false
    t.bigint "reviewer_id"
    t.enum "state", default: "drafted", null: false, enum_type: "expense_state"
    t.datetime "submitted_at", precision: nil
    t.datetime "reviewed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_expenses_on_employee_id"
    t.index ["reviewer_id"], name: "index_expenses_on_reviewer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.enum "role", default: "employee", null: false, enum_type: "user_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "expenses", "users", column: "employee_id"
  add_foreign_key "expenses", "users", column: "reviewer_id"
end
