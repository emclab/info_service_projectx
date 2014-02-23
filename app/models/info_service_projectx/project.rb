module InfoServiceProjectx
  class Project < ActiveRecord::Base
    
    attr_accessor :sales_name, :last_updated_by_name, :project_member_name, :status_name,  :cancelled_noupdate, :status_id_noupdate, :decommission_noupdate,
                  :last_updated_by_name, :customer_name
    
    attr_accessible :cancelled, :customer_id, :decommissioned_date, :decommission_reason, :decommissioned,  :status_id, :cancelled_date, :cancell_reason,
                    :fully_online_date, :initial_online_date, :last_updated_by_id, :name, :project_desp, :develop_start_date, :develop_finish_date, 
                    :project_members_attributes, :service_num, :customer_name,
                    :as => :role_new
    
    attr_accessible :cancelled, :customer_id, :decommissioned_date, :decommission_reason, :decommissioned,  :cancelled_date, :cancell_reason,
                    :fully_online_date, :initial_online_date, :last_updated_by_id, :name, :project_desp, :develop_start_date, :develop_finish_date, :status_id, 
                    :project_members_attributes, :service_num, 
                    :cancelled_noupdate, :decommission_noupdate, :last_updated_by_name, :customer_name, :status_name,
                    :as => :role_update
                    
    attr_accessor :project_id_s, :keyword_s, :start_date_s, :fully_online_date_s, :customer_id_s, :status_s, :service_num_s,
                  :zone_id_s, :sales_id_s, :initial_online_date_s, :project_manager_id_s, :developer_id_s,
                  :time_frame_s

    attr_accessible :project_id_s, :keyword_s, :start_date_s, :fully_online_date_s, :customer_id_s, :status_s, 
                    :time_frame_s, :project_member_id_s, :service_num_s,
                    :as => :role_search_stats

                    
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :customer, :class_name => InfoServiceProjectx.customer_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    has_many :project_members, :class_name => 'InfoServiceProjectx::ProjectMember'
    accepts_nested_attributes_for :project_members, :allow_destroy => true
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :customer_id, :status_id, :presence => true,
                                        :numericality => {:greater_than => 0} 
                        
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = InfoServiceProjectx.customer_class.find_by_name(name) if name.present?
    end
  end
end
