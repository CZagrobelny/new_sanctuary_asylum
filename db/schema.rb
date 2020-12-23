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

ActiveRecord::Schema.define(version: 2020_12_23_012526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_time_slots", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "use", null: false
    t.integer "grantor_id", null: false
    t.integer "grantee_id", null: false
    t.bigint "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_access_time_slots_on_community_id"
  end

  create_table "accompaniment_reports", id: :serial, force: :cascade do |t|
    t.integer "activity_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "outcome_of_hearing"
    t.bigint "friend_id"
  end

  create_table "accompaniments", id: :serial, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "user_id"
    t.text "availability_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "friend_id"
    t.integer "judge_id"
    t.datetime "occur_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "region_id"
    t.boolean "confirmed"
    t.integer "activity_type_id"
    t.text "public_notes"
    t.boolean "occur_at_tbd"
    t.datetime "control_date"
    t.integer "last_edited_by"
    t.index ["activity_type_id"], name: "index_activities_on_activity_type_id"
    t.index ["region_id"], name: "index_activities_on_region_id"
  end

  create_table "activity_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "cap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accompaniment_eligible", default: false
    t.boolean "eoir_caller_editable", default: false
  end

  create_table "ankle_monitors", force: :cascade do |t|
    t.datetime "date_removed"
    t.boolean "bi_smart_link"
    t.text "notes"
    t.bigint "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_applied"
    t.index ["friend_id"], name: "index_ankle_monitors_on_friend_id"
  end

  create_table "applications", id: :serial, force: :cascade do |t|
    t.integer "status"
    t.datetime "first_submitted_on"
    t.datetime "approved_on"
    t.integer "friend_id"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_applications_on_friend_id"
  end

  create_table "cohorts", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.string "color", null: false
    t.bigint "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_cohorts_on_community_id"
  end

  create_table "communities", id: :serial, force: :cascade do |t|
    t.integer "region_id"
    t.string "name"
    t.string "slug"
    t.boolean "primary"
    t.index ["region_id"], name: "index_communities_on_region_id"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "detentions", id: :serial, force: :cascade do |t|
    t.integer "friend_id", null: false
    t.date "date_detained"
    t.integer "location_id"
    t.text "notes"
    t.date "date_released"
    t.string "case_status"
    t.string "other_case_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drafts", id: :serial, force: :cascade do |t|
    t.text "notes"
    t.integer "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pdf_draft"
    t.integer "application_id"
    t.integer "status", default: 0
    t.index ["application_id"], name: "index_drafts_on_application_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.datetime "date"
    t.integer "location_id"
    t.string "title", default: ""
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "community_id"
    t.index ["community_id"], name: "index_events_on_community_id"
  end

  create_table "family_relationships", id: :serial, force: :cascade do |t|
    t.integer "friend_id"
    t.integer "relation_id"
    t.string "relationship_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_family_relationships_on_friend_id"
    t.index ["relation_id"], name: "index_family_relationships_on_relation_id"
  end

  create_table "friend_cohort_assignments", force: :cascade do |t|
    t.integer "friend_id", null: false
    t.integer "cohort_id", null: false
    t.boolean "confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friend_event_attendances", id: :serial, force: :cascade do |t|
    t.integer "friend_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friend_languages", id: :serial, force: :cascade do |t|
    t.integer "friend_id", null: false
    t.integer "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friend_languages_on_friend_id"
    t.index ["language_id"], name: "index_friend_languages_on_language_id"
  end

  create_table "friend_notes", force: :cascade do |t|
    t.bigint "friend_id", null: false
    t.bigint "user_id", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friend_notes_on_friend_id"
    t.index ["user_id"], name: "index_friend_notes_on_user_id"
  end

  create_table "friend_social_work_referral_categories", force: :cascade do |t|
    t.bigint "friend_id", null: false
    t.bigint "social_work_referral_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friend_social_work_referral_categories_on_friend_id"
    t.index ["social_work_referral_category_id"], name: "index_fswrc_on_swrc_id"
  end

  create_table "friends", id: :serial, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.string "email"
    t.string "a_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "middle_name"
    t.boolean "no_a_number", default: false, null: false
    t.integer "ethnicity"
    t.string "other_ethnicity"
    t.integer "gender"
    t.date "date_of_birth"
    t.string "status"
    t.date "date_of_entry"
    t.text "notes"
    t.string "asylum_status"
    t.date "date_asylum_application_submitted"
    t.text "lawyer_notes"
    t.string "work_authorization_status"
    t.date "date_eligible_to_apply_for_work_authorization"
    t.date "date_work_authorization_submitted"
    t.text "work_authorization_notes"
    t.string "sijs_status"
    t.date "date_sijs_submitted"
    t.text "sijs_notes"
    t.text "asylum_notes"
    t.integer "country_id"
    t.integer "lawyer_referred_to"
    t.integer "lawyer_represented_by"
    t.integer "sijs_lawyer"
    t.string "zip_code"
    t.boolean "criminal_conviction"
    t.text "criminal_conviction_notes"
    t.boolean "final_order_of_removal"
    t.boolean "has_a_lawyer_for_detention"
    t.boolean "bonded_out_by_nsc"
    t.integer "bond_amount"
    t.datetime "date_bonded_out"
    t.integer "bonded_out_by"
    t.datetime "date_foia_request_submitted"
    t.text "foia_request_notes"
    t.integer "community_id"
    t.integer "region_id"
    t.string "state"
    t.string "sponsor_name"
    t.string "sponsor_phone_number"
    t.string "sponsor_relationship"
    t.string "city"
    t.string "jail_id"
    t.text "intake_notes"
    t.datetime "intake_date"
    t.datetime "must_be_seen_by"
    t.string "eoir_case_status"
    t.boolean "digitized", default: false
    t.datetime "digitized_at"
    t.integer "digitized_by"
    t.boolean "invited_to_speak_to_a_lawyer"
    t.boolean "releases_signed"
    t.text "social_work_referral_notes"
    t.boolean "famu_docket", default: false
    t.boolean "no_record_in_eoir", default: false
    t.boolean "order_of_supervision", default: false
    t.string "clinic_plan"
    t.datetime "judge_imposed_i589_deadline"
    t.boolean "has_a_lawyer"
    t.string "lawyer_name"
    t.index ["community_id"], name: "index_friends_on_community_id"
    t.index ["region_id"], name: "index_friends_on_region_id"
  end

  create_table "judges", id: :serial, force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "region_id"
    t.boolean "hidden", default: false
    t.index ["region_id"], name: "index_judges_on_region_id"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "lawyers", id: :serial, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "organization"
    t.string "phone_number"
    t.integer "region_id"
    t.index ["region_id"], name: "index_lawyers_on_region_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "region_id"
    t.index ["region_id"], name: "index_locations_on_region_id"
  end

  create_table "old_passwords", id: :serial, force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.string "password_salt"
    t.integer "password_archivable_id", null: false
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "remote_review_actions", force: :cascade do |t|
    t.string "action", null: false
    t.integer "friend_id", null: false
    t.integer "user_id", null: false
    t.integer "region_id", null: false
    t.integer "community_id", null: false
    t.integer "application_id", null: false
    t.integer "draft_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_remote_review_actions_on_region_id"
  end

  create_table "reviews", id: :serial, force: :cascade do |t|
    t.text "notes"
    t.integer "draft_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["draft_id"], name: "index_reviews_on_draft_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sanctuaries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state", limit: 2
    t.string "zip_code"
    t.string "leader_name"
    t.string "leader_phone_number"
    t.string "leader_email"
    t.integer "community_id"
    t.index ["community_id"], name: "index_sanctuaries_on_community_id"
  end

  create_table "sijs_application_drafts", id: :serial, force: :cascade do |t|
    t.text "notes"
    t.integer "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pdf_draft", null: false
  end

  create_table "social_work_referral_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_draft_associations", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "draft_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_event_attendances", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_friend_associations", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "remote", default: false
    t.index ["friend_id"], name: "index_user_friend_associations_on_friend_id"
    t.index ["user_id"], name: "index_user_friend_associations_on_user_id"
  end

  create_table "user_regions", id: :serial, force: :cascade do |t|
    t.integer "region_id"
    t.integer "user_id"
    t.index ["region_id"], name: "index_user_regions_on_region_id"
    t.index ["user_id"], name: "index_user_regions_on_user_id"
  end

  create_table "user_sijs_application_draft_associations", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "sijs_application_draft_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "role", default: 0
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "volunteer_type"
    t.boolean "pledge_signed", default: false
    t.string "unique_session_id", limit: 20
    t.datetime "password_changed_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "signed_guidelines"
    t.integer "community_id"
    t.boolean "attended_training"
    t.string "authy_id"
    t.datetime "last_sign_in_with_authy"
    t.boolean "authy_enabled", default: false
    t.boolean "agreed_to_data_entry_policies", default: false
    t.index ["authy_id"], name: "index_users_on_authy_id"
    t.index ["community_id"], name: "index_users_on_community_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "volunteer_languages", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_volunteer_languages_on_language_id"
    t.index ["user_id"], name: "index_volunteer_languages_on_user_id"
  end

  add_foreign_key "activities", "activity_types"
  add_foreign_key "activities", "regions"
  add_foreign_key "communities", "regions"
  add_foreign_key "events", "communities"
  add_foreign_key "friend_notes", "friends"
  add_foreign_key "friend_notes", "users"
  add_foreign_key "friends", "communities"
  add_foreign_key "friends", "regions"
  add_foreign_key "judges", "regions"
  add_foreign_key "lawyers", "regions"
  add_foreign_key "locations", "regions"
  add_foreign_key "sanctuaries", "communities"
  add_foreign_key "user_regions", "regions"
  add_foreign_key "user_regions", "users"
  add_foreign_key "users", "communities"
end
