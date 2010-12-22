# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101222154128) do

  create_table "actors", :force => true do |t|
    t.string   "actor_type"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "address_by_dates", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "address_line_4"
    t.string   "zip_code"
    t.integer  "district_id"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "albums", :force => true do |t|
    t.integer "picture_id"
    t.integer "owner_id"
    t.string  "owner_type"
  end

  create_table "brain_busters", :force => true do |t|
    t.string "question"
    t.string "answer"
    t.string "locale"
  end

  create_table "brands", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.string  "site"
    t.boolean "validated"
    t.boolean "checked"
  end

  create_table "caches", :force => true do |t|
    t.integer  "company_id"
    t.integer  "merchan_id"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_category_id"
    t.string   "name"
    t.integer  "sequence"
    t.text     "category_comment"
    t.boolean  "validated"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "categories_companies", :force => true do |t|
    t.integer  "company_id"
    t.integer  "category_id"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "validated"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.integer  "actor_id"
    t.string   "name"
    t.text     "company_comment"
    t.string   "custom_name"
    t.string   "kind"
    t.string   "tel"
    t.string   "fax"
    t.string   "email"
    t.string   "url"
    t.boolean  "checked"
    t.date     "valid_from"
    t.date     "valid_thru"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "conversion_rates", :force => true do |t|
    t.integer "company_id"
    t.integer "currency_from"
    t.integer "currency_thru"
    t.integer "rate_from"
    t.integer "rate_thru"
  end

  create_table "currencies", :force => true do |t|
    t.string "name"
    t.string "designation"
  end

  create_table "custom_company_names", :force => true do |t|
    t.integer "actor_id"
    t.integer "company_id"
    t.string  "name"
  end

  create_table "districts", :force => true do |t|
    t.string  "name"
    t.integer "city_id"
    t.text    "description"
    t.boolean "validated"
  end

  create_table "licences", :force => true do |t|
    t.string   "name"
    t.string   "licence_number"
    t.integer  "company_id"
    t.string   "who_added"
    t.datetime "valid_thru"
  end

  create_table "master_logins", :force => true do |t|
    t.string "login"
    t.string "password"
  end

  create_table "merchandise_column_descs", :force => true do |t|
    t.text    "column_value"
    t.integer "merchandise_id"
    t.string  "unit_of"
    t.boolean "validated"
  end

  create_table "merchandise_column_names", :force => true do |t|
    t.string  "column_name"
    t.integer "category_id"
    t.text    "description"
    t.boolean "validated"
  end

  create_table "merchandises", :force => true do |t|
    t.integer  "category_id"
    t.integer  "brand_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "validated"
    t.boolean  "checked"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.integer  "actor_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "position"
    t.string   "phone"
    t.string   "mobile"
    t.string   "fax"
    t.string   "email"
    t.date     "birthday"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string  "title"
    t.string  "content_type"
    t.binary  "data"
    t.binary  "icon_data"
    t.boolean "validated",    :default => false
  end

  create_table "price_by_dates", :force => true do |t|
    t.integer  "company_id"
    t.integer  "merchan_id"
    t.integer  "price_id"
    t.string   "price_type"
    t.datetime "price_date"
    t.integer  "quantity"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.integer  "currency_id"
    t.integer  "amount"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 30
    t.integer  "authorizable_id"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
  end

  create_table "stats_logins", :force => true do |t|
    t.string   "login"
    t.datetime "login_at"
    t.string   "login_type"
  end

  create_table "users", :force => true do |t|
    t.integer  "actor_id"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password", :limit => 40
    t.string   "salt",             :limit => 40
    t.string   "created_by"
    t.datetime "created_at"
    t.string   "updated_by"
    t.datetime "updated_at"
    t.string   "activation_code",  :limit => 40
    t.datetime "activated_at"
  end

end
