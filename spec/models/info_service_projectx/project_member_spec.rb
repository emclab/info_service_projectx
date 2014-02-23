require 'spec_helper'

module InfoServiceProjectx
  describe ProjectMember do
    it "should be OK" do
      i = FactoryGirl.build(:info_service_projectx_project_member, :active_end_date => nil, active: true)
      i.should be_valid
    end
    
    it "should reject 0 user_id" do
      i = FactoryGirl.build(:info_service_projectx_project_member, user_id: 0)
      i.should_not be_valid
    end
  
    it "should reject 0 project_id" do
      i = FactoryGirl.build(:info_service_projectx_project_member, project_id: 0)
      i.should_not be_valid
    end
    
    it "should reject 0 project_role_id" do
      i = FactoryGirl.build(:info_service_projectx_project_member, project_role_id: 0)
      i.should_not be_valid
    end
    
    it "should reject nil active_end_date if active is false" do
      i = FactoryGirl.build(:info_service_projectx_project_member, active: false, active_end_date: nil)
      i.should_not be_valid
    end
    
    it "should not allow active_end_date if active is true" do
      i = FactoryGirl.build(:info_service_projectx_project_member, active: true, active_end_date: '2014-02-10')
      i.should_not be_valid
    end
    
    it "should allow nil active_end_date if active is true" do
      i = FactoryGirl.build(:info_service_projectx_project_member, active: true, active_end_date: nil)
      i.should be_valid
    end
    
    
  end
end
