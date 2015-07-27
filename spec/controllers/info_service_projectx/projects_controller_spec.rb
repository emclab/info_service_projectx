require 'rails_helper'

module InfoServiceProjectx
  RSpec.describe ProjectsController, type: :controller do
    routes {InfoServiceProjectx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      #controller.should_receive(:require_employee)
    end
    before(:each) do
      #@project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'heavy_machinery_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' InfoServiceProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (InfoServiceProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @cust = FactoryGirl.create(:kustomerx_customer)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :customer_id => @cust.id)
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all projects for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InfoServiceProjectx::Project.where(:cancelled => false).order('id')")  
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:info_service_projectx_project, :cancelled => false, :last_updated_by_id => @u.id)
        qs1 = FactoryGirl.create(:info_service_projectx_project, :cancelled => false, :last_updated_by_id => @u.id,  :name => 'newnew')
        get 'index' 
        expect(assigns(:projects)).to match_array( [qs, qs1])       
      end
      
      it "should return project for the project_type" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InfoServiceProjectx::Project.where(:cancelled => false).order('id')")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:info_service_projectx_project, :cancelled => false, :last_updated_by_id => @u.id)
        qs1 = FactoryGirl.create(:info_service_projectx_project, :cancelled => true, :last_updated_by_id => @u.id,  :name => 'newnew')
        get 'index' 
        expect(assigns(:projects)).to eq([qs])
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        get 'new' 
        expect(response).to be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:info_service_projectx_project)
        get 'create' , {  :project => qs}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:info_service_projectx_project, :name => nil)
        get 'create' , {  :project => qs}
        expect(response).to render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:info_service_projectx_project, :customer_id => @cust.id)
        get 'edit' , {  :id => qs.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:info_service_projectx_project)
        get 'update' , {  :id => qs.id, :project => {:name => 'newnew'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:info_service_projectx_project)
        get 'update' , {  :id => qs.id, :project => {:name => nil}}
        expect(response).to render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:info_service_projectx_project)
        get 'show' , {  :id => qs.id}
        expect(response).to be_success
      end
    end
    
    describe "Index for customer" do
      it "should return customer's project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_for_customer', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InfoServiceProjectx::Project.where(:customer_id => session[:session_customer_id]).order('id')")  
        session[:user_id] = @u.id
        session[:session_customer_id] = @cust.id
        qs = FactoryGirl.create(:info_service_projectx_project, :cancelled => false, :last_updated_by_id => @u.id, :customer_id => @cust.id)
        qs1 = FactoryGirl.create(:info_service_projectx_project, :cancelled => false, :last_updated_by_id => @u.id,  :name => 'newnew', :customer_id => @cust.id + 1)
        get 'index_for_customer' , { :customer_id => @cust.id }
        expect(assigns(:projects)).to match_array( [qs])    
      end
    end
  
  end
end
