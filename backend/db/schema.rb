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

ActiveRecord::Schema[8.0].define(version: 2025_12_01_002107) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.bigint "discussion_thread_id", null: false
    t.bigint "tenant_id", null: false
    t.string "url"
    t.text "extrainfo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_thread_id"], name: "index_attachments_on_discussion_thread_id"
    t.index ["tenant_id"], name: "index_attachments_on_tenant_id"
  end

  create_table "discussion_threads", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "task_id", null: false
    t.string "title"
    t.text "body"
    t.integer "status", default: 0, null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.index ["created_by_id"], name: "index_discussion_threads_on_created_by_id"
    t.index ["project_id"], name: "index_discussion_threads_on_project_id"
    t.index ["task_id"], name: "index_discussion_threads_on_task_id"
    t.index ["tenant_id"], name: "index_discussion_threads_on_tenant_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.date "target_date"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["created_by_id"], name: "index_projects_on_created_by_id"
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
    t.index ["tenant_id"], name: "index_projects_on_tenant_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token_digest"
    t.datetime "expires_at"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "replies", force: :cascade do |t|
    t.bigint "discussion_thread_id", null: false
    t.bigint "tenant_id", null: false
    t.bigint "created_by_id", null: false
    t.text "body"
    t.integer "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_replies_on_created_by_id"
    t.index ["discussion_thread_id"], name: "index_replies_on_discussion_thread_id"
    t.index ["tenant_id"], name: "index_replies_on_tenant_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "project_id", null: false
    t.string "title"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.integer "priority"
    t.bigint "assignee_id", null: false
    t.bigint "created_by_id", null: false
    t.date "due_date"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id"
    t.index ["created_by_id"], name: "index_tasks_on_created_by_id"
    t.index ["deleted_at"], name: "index_tasks_on_deleted_at"
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["tenant_id"], name: "index_tasks_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 2, null: false
    t.bigint "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "attachments", "discussion_threads"
  add_foreign_key "attachments", "tenants"
  add_foreign_key "discussion_threads", "projects"
  add_foreign_key "discussion_threads", "tasks"
  add_foreign_key "discussion_threads", "tenants"
  add_foreign_key "discussion_threads", "users", column: "created_by_id"
  add_foreign_key "projects", "tenants"
  add_foreign_key "projects", "users", column: "created_by_id"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "replies", "discussion_threads"
  add_foreign_key "replies", "tenants"
  add_foreign_key "replies", "users", column: "created_by_id"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "tenants"
  add_foreign_key "tasks", "users", column: "assignee_id"
  add_foreign_key "tasks", "users", column: "created_by_id"
  add_foreign_key "users", "tenants"
end
