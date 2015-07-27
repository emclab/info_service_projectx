require 'rails_helper'

module InfoServiceProjectx
  RSpec.describe Project, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:info_service_projectx_project) 
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:info_service_projectx_project, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject duplidate name" do
      c = FactoryGirl.create(:info_service_projectx_project, :name => 'test')
      c1 = FactoryGirl.build(:info_service_projectx_project, :name => 'Test')
      expect(c1).not_to be_valid
    end
    
    it "should reject 0 status_id" do
      c = FactoryGirl.build(:info_service_projectx_project, :status_id => 0)
      expect(c).not_to be_valid
    end
  end
end
