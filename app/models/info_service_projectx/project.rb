
module InfoServiceProjectx
  class Project < ActiveRecord::Base
    
    attr_accessor :sales_name, :last_updated_by_name, :project_member_name, :status_name,  :cancelled_noupdate, :status_id_noupdate, :decommission_noupdate,
                  :last_updated_by_name, :customer_name, :project_category_name, :sales_name, :project_manager_name, :field_changed
                    
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :project_category, :class_name => 'Commonx::MiscDefinition'
    belongs_to :customer, :class_name => InfoServiceProjectx.customer_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :sales, :class_name => 'Authentify::User'
    belongs_to :project_manager, :class_name => 'Authentify::User'
    
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
