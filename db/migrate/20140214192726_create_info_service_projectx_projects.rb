class CreateInfoServiceProjectxProjects < ActiveRecord::Migration
  def change
    create_table :info_service_projectx_projects do |t|
      t.integer :customer_id
      t.integer :service_num
      t.string :name
      t.text :project_desp
      t.date :develop_start_date
      t.date :develop_finish_date
      t.integer :status_id
      t.integer :last_updated_by_id
      t.boolean :cancelled, :default => false
      t.boolean :decommissioned, :default => false
      t.date :cancelled_date
      t.text :cancell_reason
      t.date :decommissioned_date
      t.text :decommission_reason
      t.date :initial_online_date
      t.date :fully_online_date
      t.timestamps
      t.integer :project_category_id
      t.integer :sales_id
      t.integer :project_manager_id
    end
    
    add_index :info_service_projectx_projects, :customer_id
    add_index :info_service_projectx_projects, :name
    add_index :info_service_projectx_projects, :service_num
    add_index :info_service_projectx_projects, :status_id
    add_index :info_service_projectx_projects, :decommissioned
    add_index :info_service_projectx_projects, :cancelled
    add_index :info_service_projectx_projects, [:cancelled, :decommissioned], :name => :info_service_projectx_projects_2_boolean
    add_index :info_service_projectx_projects, :project_category_id
    add_index :info_service_projectx_projects, :sales_id
    add_index :info_service_projectx_projects, :project_manager_id
  end
end
