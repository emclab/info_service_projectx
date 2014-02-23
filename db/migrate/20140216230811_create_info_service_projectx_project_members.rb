class CreateInfoServiceProjectxProjectMembers < ActiveRecord::Migration
  def change
    create_table :info_service_projectx_project_members do |t|
      t.integer :project_id
      t.integer :user_id
      t.boolean :active, :default => true
      t.date :active_end_date
      t.boolean :project_role_lead, :default => false
      t.integer :project_role_id
      t.text :brief_note

      t.timestamps
    end
    
    add_index :info_service_projectx_project_members, :project_id
    add_index :info_service_projectx_project_members, :user_id
    add_index :info_service_projectx_project_members, :project_role_id
    add_index :info_service_projectx_project_members, :active
    add_index :info_service_projectx_project_members, :project_role_lead, :name => :info_service_projectx_project_members_lead
  end
end
