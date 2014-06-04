require 'spec_helper'

module InfoServiceProjectx
  describe Project do
    it "should be OK" do
      c = FactoryGirl.build(:info_service_projectx_project) 
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:info_service_projectx_project, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject duplidate name" do
      c = FactoryGirl.create(:info_service_projectx_project, :name => 'test')
      c1 = FactoryGirl.build(:info_service_projectx_project, :name => 'Test')
      c1.should_not be_valid
    end
    
    it "should reject 0 status_id" do
      c = FactoryGirl.build(:info_service_projectx_project, :status_id => 0)
      c.should_not be_valid
    end
  end
end
