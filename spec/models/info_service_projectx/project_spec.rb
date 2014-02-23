require 'spec_helper'

module InfoServiceProjectx
  describe Project do
    it "should be OK" do
      add = FactoryGirl.build(:info_service_projectx_project_member, :active_end_date => nil, active: true)
      c = FactoryGirl.build(:info_service_projectx_project, :project_members => [add]) 
      c.should be_valid
    end
    
    it "should reject nil name" do
      add = FactoryGirl.build(:info_service_projectx_project_member, :active_end_date => nil, active: true)
      c = FactoryGirl.build(:info_service_projectx_project, :name => nil, :project_members => [add])
      c.should_not be_valid
    end
    
    it "should reject nil user_id in member info" do
      add = FactoryGirl.build(:info_service_projectx_project_member, :user_id => 0, :active_end_date => nil, active: true)
      c = FactoryGirl.build(:info_service_projectx_project, :project_members => [add])
      c.should_not be_valid
    end  
    
    it "should reject duplidate name" do
      add = FactoryGirl.build(:info_service_projectx_project_member, :active_end_date => nil, active: true)
      #c = FactoryGirl.create(:info_service_projectx_project, :name => 'test1', :project_members => [add])
      c = FactoryGirl.create(:info_service_projectx_project, :name => 'test', :project_members => [add])
      c1 = FactoryGirl.build(:info_service_projectx_project, :name => 'Test', :project_members => [add])
      c1.should_not be_valid
    end
    
    it "should reject 0 status_id" do
      add = FactoryGirl.build(:info_service_projectx_project_member, :active_end_date => nil, active: true)
      c = FactoryGirl.build(:info_service_projectx_project, :status_id => 0, :project_members => [add])
      c.should_not be_valid
    end
  end
end
