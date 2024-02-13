# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_04_26_184407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "rut", null: false
    t.string "email", null: false
    t.bigint "relation_id", null: false
    t.bigint "bank_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_type"
    t.bigint "country_id"
    t.decimal "updated_balance", default: "0.0"
    t.string "status"
    t.index ["bank_id"], name: "index_accounts_on_bank_id"
    t.index ["country_id"], name: "index_accounts_on_country_id"
    t.index ["relation_id"], name: "index_accounts_on_relation_id"
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "adviser_relations", force: :cascade do |t|
    t.bigint "adviser_id", null: false
    t.bigint "relation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["adviser_id"], name: "index_adviser_relations_on_adviser_id"
    t.index ["relation_id"], name: "index_adviser_relations_on_relation_id"
  end

  create_table "advisers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token", limit: 30
    t.string "rut", limit: 12
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.boolean "active", default: true, null: false
    t.index ["authentication_token"], name: "index_advisers_on_authentication_token", unique: true
    t.index ["email"], name: "index_advisers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_advisers_on_reset_password_token", unique: true
    t.index ["rut"], name: "index_advisers_on_rut", unique: true
  end

  create_table "alternative_names", force: :cascade do |t|
    t.string "name"
    t.bigint "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_alternative_names_on_membership_id"
  end

  create_table "aums", force: :cascade do |t|
    t.text "aum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_aums_on_created_at"
  end

  create_table "banks", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "communes", force: :cascade do |t|
    t.string "name"
    t.integer "code_sii"
    t.integer "code_tesoreria"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "name_eng"
    t.string "iso"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "continent"
  end

  create_table "dollar_prices", force: :cascade do |t|
    t.float "price", null: false
    t.datetime "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_dollar_prices_on_date", unique: true
  end

  create_table "euro_prices", force: :cascade do |t|
    t.float "price", null: false
    t.datetime "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_euro_prices_on_date", unique: true
  end

  create_table "external_value_changes", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.float "total_value"
    t.date "date"
    t.string "valuer"
    t.integer "type_valuer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_external_value_changes_on_membership_id"
  end

  create_table "insurance_files", force: :cascade do |t|
    t.bigint "insurance_id"
    t.jsonb "file_data"
    t.index ["insurance_id"], name: "index_insurance_files_on_insurance_id"
  end

  create_table "insurances", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.string "name"
    t.string "insuree"
    t.text "details"
    t.float "prime"
    t.float "insured_capital"
    t.datetime "policy_end"
    t.datetime "policy_renovation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "insurance_file_id"
    t.float "initial_investment"
    t.string "beneficiary"
    t.index ["membership_id"], name: "index_insurances_on_membership_id"
  end

  create_table "investment_assets", force: :cascade do |t|
    t.string "name", null: false
    t.string "asset_id", null: false
    t.integer "currency", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "valid_asset", default: false
    t.integer "asset_type"
    t.boolean "is_custom", default: false
    t.float "mtd"
    t.float "recovery_level"
    t.float "qtd"
    t.float "ytd"
    t.float "y1"
    t.float "y3"
    t.float "y5"
    t.string "sub_sector"
    t.float "average_annual_cost"
    t.jsonb "countries_distribution"
    t.index ["asset_id"], name: "index_investment_assets_on_asset_id", unique: true
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "ledgerizer_accounts", force: :cascade do |t|
    t.string "tenant_type"
    t.bigint "tenant_id"
    t.string "accountable_type"
    t.bigint "accountable_id"
    t.string "name"
    t.string "currency"
    t.string "account_type"
    t.string "mirror_currency"
    t.bigint "balance_cents", default: 0, null: false
    t.string "balance_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accountable_type", "accountable_id", "name", "mirror_currency", "currency", "tenant_id", "tenant_type"], name: "unique_account_index", unique: true
    t.index ["accountable_type", "accountable_id"], name: "index_ledgerizer_accounts_on_acc_type_and_acc_id"
    t.index ["tenant_type", "tenant_id"], name: "index_ledgerizer_accounts_on_tenant_type_and_tenant_id"
  end

  create_table "ledgerizer_entries", force: :cascade do |t|
    t.string "tenant_type"
    t.bigint "tenant_id"
    t.string "code"
    t.string "document_type"
    t.bigint "document_id"
    t.datetime "entry_time"
    t.string "mirror_currency"
    t.bigint "conversion_amount_cents"
    t.string "conversion_amount_currency", default: "USD", null: false
    t.index ["document_type", "document_id"], name: "index_ledgerizer_entries_on_document_type_and_document_id"
    t.index ["tenant_id", "tenant_type", "document_id", "document_type", "code", "mirror_currency"], name: "unique_entry_index", unique: true
    t.index ["tenant_type", "tenant_id"], name: "index_ledgerizer_entries_on_tenant_type_and_tenant_id"
  end

  create_table "ledgerizer_lines", force: :cascade do |t|
    t.bigint "entry_id"
    t.datetime "entry_time"
    t.string "entry_code"
    t.bigint "account_id"
    t.string "account_type"
    t.string "account_name"
    t.string "account_mirror_currency"
    t.string "tenant_type"
    t.bigint "tenant_id"
    t.string "document_type"
    t.bigint "document_id"
    t.string "accountable_type"
    t.bigint "accountable_id"
    t.bigint "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.bigint "balance_cents", default: 0, null: false
    t.string "balance_currency", default: "USD", null: false
    t.index ["account_id"], name: "index_ledgerizer_lines_on_account_id"
    t.index ["accountable_type", "accountable_id"], name: "index_ledgerizer_lines_on_accountable_type_and_accountable_id"
    t.index ["document_type", "document_id"], name: "index_ledgerizer_lines_on_document_type_and_document_id"
    t.index ["entry_id"], name: "index_ledgerizer_lines_on_entry_id"
    t.index ["tenant_type", "tenant_id"], name: "index_ledgerizer_lines_on_tenant_type_and_tenant_id"
  end

  create_table "ledgerizer_revaluations", force: :cascade do |t|
    t.string "tenant_type"
    t.bigint "tenant_id"
    t.string "currency"
    t.datetime "revaluation_time"
    t.bigint "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.index ["tenant_id", "tenant_type", "revaluation_time", "currency"], name: "unique_revaluations_index", unique: true
    t.index ["tenant_type", "tenant_id"], name: "index_ledgerizer_revaluations_on_tenant_type_and_tenant_id"
  end

  create_table "liabilities", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.bigint "investment_asset_id"
    t.string "name"
    t.text "description"
    t.float "initial_debt"
    t.float "debt_participation"
    t.integer "total_fees"
    t.integer "fees_paid"
    t.integer "outstanding_balance"
    t.date "start_date"
    t.date "end_date"
    t.integer "payment_cycle"
    t.float "rate"
    t.string "rate_description"
    t.integer "rate_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["investment_asset_id"], name: "index_liabilities_on_investment_asset_id"
    t.index ["membership_id"], name: "index_liabilities_on_membership_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "sub_account_id", null: false
    t.bigint "investment_asset_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "hidden", default: false
    t.decimal "updated_balance", default: "0.0"
    t.string "status"
    t.index ["investment_asset_id"], name: "index_memberships_on_investment_asset_id"
    t.index ["sub_account_id"], name: "index_memberships_on_sub_account_id"
  end

  create_table "money_movements", force: :cascade do |t|
    t.float "quotas", null: false
    t.datetime "date", null: false
    t.bigint "sub_account_id", null: false
    t.bigint "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "movement_type"
    t.float "average_price"
    t.integer "deleted_by_id"
    t.float "fee_outstanding_balance"
    t.integer "fee_number"
    t.index ["membership_id"], name: "index_money_movements_on_membership_id"
    t.index ["sub_account_id"], name: "index_money_movements_on_sub_account_id"
  end

  create_table "others_memberships", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.string "name"
    t.text "description"
    t.integer "total_investment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity"
    t.index ["membership_id"], name: "index_others_memberships_on_membership_id"
  end

  create_table "price_change_documents", force: :cascade do |t|
    t.bigint "price_change_id", null: false
    t.bigint "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_price_change_documents_on_membership_id"
    t.index ["price_change_id"], name: "index_price_change_documents_on_price_change_id"
  end

  create_table "price_changes", force: :cascade do |t|
    t.float "value", null: false
    t.datetime "price_changed_at", null: false
    t.bigint "investment_asset_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "money_movement_id"
    t.boolean "from_file", default: false
    t.index ["investment_asset_id"], name: "index_price_changes_on_investment_asset_id"
    t.index ["money_movement_id"], name: "index_price_changes_on_money_movement_id"
  end

  create_table "re_value_changes", force: :cascade do |t|
    t.bigint "real_estate_id", null: false
    t.float "builded_value"
    t.float "area_value"
    t.float "total_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date"
    t.string "valuer"
    t.integer "type_valuer"
    t.index ["real_estate_id"], name: "index_re_value_changes_on_real_estate_id"
  end

  create_table "real_estates", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.string "commune"
    t.string "role"
    t.string "lat"
    t.string "lon"
    t.string "location_sql"
    t.string "address"
    t.string "asset_destination"
    t.float "contributions"
    t.float "fiscal_appraisal"
    t.float "area"
    t.float "builded_area"
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "force_update", default: false
    t.string "name"
    t.integer "total_inversion"
    t.index ["membership_id"], name: "index_real_estates_on_membership_id"
  end

  create_table "relation_files", force: :cascade do |t|
    t.bigint "relation_id", null: false
    t.bigint "account_id"
    t.bigint "sub_account_id"
    t.bigint "bank_id"
    t.string "name"
    t.date "date"
    t.integer "document_type"
    t.jsonb "file_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_relation_files_on_account_id"
    t.index ["bank_id"], name: "index_relation_files_on_bank_id"
    t.index ["relation_id"], name: "index_relation_files_on_relation_id"
    t.index ["sub_account_id"], name: "index_relation_files_on_sub_account_id"
  end

  create_table "relation_histories", force: :cascade do |t|
    t.bigint "relation_id", null: false
    t.integer "time_window"
    t.jsonb "wallet_values", default: {}, null: false
    t.jsonb "balances_values", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["relation_id"], name: "index_relation_histories_on_relation_id"
  end

  create_table "relations", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "rut", null: false
    t.string "email", null: false
    t.string "phone"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "show_wallet", default: false
    t.string "authentication_token", limit: 30
    t.boolean "active", default: true, null: false
    t.decimal "updated_balance", default: "0.0"
    t.string "status"
    t.text "vars"
    t.jsonb "modules", default: {"chart_top_distribution_module"=>true, "chart_country_distribution_module"=>true, "chart_currency_distribution_module"=>true, "chart_asset_type_distribution_module"=>true, "chart_institution_distribution_module"=>true, "chart_ambiental_vars_distribution_module"=>true, "chart_asset_classify_distribution_module"=>true}
    t.index ["authentication_token"], name: "index_relations_on_authentication_token", unique: true
    t.index ["email"], name: "index_relations_on_email", unique: true
    t.index ["reset_password_token"], name: "index_relations_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_relations_on_user_id"
  end

  create_table "sub_accounts", force: :cascade do |t|
    t.integer "currency", null: false
    t.string "sub_account_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "updated_balance", default: "0.0"
    t.string "status"
    t.index ["account_id"], name: "index_sub_accounts_on_account_id"
  end

  create_table "supervisor_advisers", force: :cascade do |t|
    t.bigint "supervisor_id"
    t.bigint "adviser_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["adviser_id"], name: "index_supervisor_advisers_on_adviser_id"
    t.index ["supervisor_id"], name: "index_supervisor_advisers_on_supervisor_id"
  end

  create_table "supervisors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "vendor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token", limit: 30
    t.string "rut", limit: 12
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.boolean "active", default: true, null: false
    t.index ["authentication_token"], name: "index_supervisors_on_authentication_token", unique: true
    t.index ["email"], name: "index_supervisors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_supervisors_on_reset_password_token", unique: true
    t.index ["rut"], name: "index_supervisors_on_rut", unique: true
    t.index ["vendor_id"], name: "index_supervisors_on_vendor_id"
  end

  create_table "uf_prices", force: :cascade do |t|
    t.float "price", null: false
    t.datetime "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_uf_prices_on_date", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone_number"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "institution"
    t.string "authentication_token", limit: 30
    t.string "rut", limit: 12
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rut"], name: "index_users_on_rut", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "vars"
  end

  create_table "wallet_deposits", force: :cascade do |t|
    t.bigint "sub_account_id", null: false
    t.date "date"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "comment"
    t.index ["sub_account_id"], name: "index_wallet_deposits_on_sub_account_id"
  end

  create_table "wallet_withdrawals", force: :cascade do |t|
    t.bigint "sub_account_id", null: false
    t.date "date"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "comment"
    t.index ["sub_account_id"], name: "index_wallet_withdrawals_on_sub_account_id"
  end

  add_foreign_key "accounts", "banks"
  add_foreign_key "accounts", "relations"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adviser_relations", "advisers"
  add_foreign_key "adviser_relations", "relations"
  add_foreign_key "alternative_names", "memberships"
  add_foreign_key "external_value_changes", "memberships"
  add_foreign_key "insurances", "memberships"
  add_foreign_key "ledgerizer_lines", "ledgerizer_accounts", column: "account_id"
  add_foreign_key "ledgerizer_lines", "ledgerizer_entries", column: "entry_id"
  add_foreign_key "liabilities", "investment_assets"
  add_foreign_key "liabilities", "memberships"
  add_foreign_key "memberships", "investment_assets"
  add_foreign_key "memberships", "sub_accounts"
  add_foreign_key "money_movements", "memberships"
  add_foreign_key "money_movements", "sub_accounts"
  add_foreign_key "others_memberships", "memberships"
  add_foreign_key "price_change_documents", "memberships"
  add_foreign_key "price_change_documents", "price_changes"
  add_foreign_key "price_changes", "investment_assets"
  add_foreign_key "re_value_changes", "real_estates"
  add_foreign_key "real_estates", "memberships"
  add_foreign_key "relation_files", "accounts"
  add_foreign_key "relation_files", "banks"
  add_foreign_key "relation_files", "relations"
  add_foreign_key "relation_files", "sub_accounts"
  add_foreign_key "relation_histories", "relations"
  add_foreign_key "relations", "users"
  add_foreign_key "sub_accounts", "accounts"
  add_foreign_key "wallet_deposits", "sub_accounts"
  add_foreign_key "wallet_withdrawals", "sub_accounts"
end
