module InfoServiceProjectx
  class ProjectMember < ActiveRecord::Base
    attr_accessible :active, :active_end_date, :brief_note, :project_id, :project_role_id, :project_role_lead, :user_id
    
    attr_accessor :active_noupdate, :project_role_lead_noupdate
    attr_accessible :active, :brief_note, :active_end_date, :project_id, :user_id, :project_role_lead, :project_role_id,
                    :as => :role_new
    attr_accessible :active, :brief_note, :active_end_date,:user_id, :project_role_lead, :project_role_id, :active_noupdate, :project_role_lead_noupdate,
                    :as => :role_update
                    
    belongs_to :user, :class_name => 'Authentify::User'
    belongs_to :project, :class_name => 'InfoServiceProjectx::Project'
    belongs_to :project_role, :class_name => 'Commonx::MiscDefinition'
    
    validates :user_id, :project_id, :project_role_id, :presence => true,
                         :numericality => {:greater_than => 0} 
    #validates :active_end_date, :presence => true, :unless => 'active' 
    validate :check_active_end_date
    
    protected
    def check_active_end_date
      if active && active_end_date.present?
        errors.add(:active_end_date, I18n.t("Should be empty!"))
      end
      
      if active == false && active_end_date.blank?
        errors.add(:active_end_date, I18n.t("Fill in date!"))
      end
    end
  end
end
