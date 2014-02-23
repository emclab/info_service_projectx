require 'spec_helper'

describe "LinkTests" do
  describe "GET /info_service_projectx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "InfoServiceProjectx::Project.where(:cancelled => false).order('id')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      ua1 = FactoryGirl.create(:user_access, :action => 'project_member', :resource => 'info_service_projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'create_project', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
    
      @proj_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_status', :active => true, :name => 'proj status')
      @proj_role = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_role', :active => true, :name => 'proj role')
      @proj_role1 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_role', :active => true, :name => 'proj role new')
      @cust = FactoryGirl.create(:kustomerx_customer)
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
      
    end
    it "works! (now write some real specs)" do
      member1 = FactoryGirl.create(:info_service_projectx_project_member, :user_id => @u.id, :project_role_id => @proj_role.id, :active => true, active_end_date: nil)
      member2 = FactoryGirl.create(:info_service_projectx_project_member, :user_id => @u.id, :project_role_id => @proj_role1.id, :active => true, active_end_date: nil)
      qs = FactoryGirl.create(:info_service_projectx_project, :cancelled => false, :last_updated_by_id => @u.id, :customer_id => @cust.id, 
                              :project_members => [member1, member2])
      visit projects_path(:customer_id => @cust.id)
      save_and_open_page
      page.should have_content('Projects')
      click_link 'New Project'
      #save_and_open_page
      page.should have_content('New Project')
      visit projects_path
      save_and_open_page
      page.should have_content('Projects')
      click_link 'New Project'
      save_and_open_page
      page.should have_content('New Project')
      visit projects_path
      click_link qs.id.to_s
      page.should have_content('Project Info')
      click_link 'New Log'
      page.should have_content('Log')
      #save_and_open_page
      visit projects_path()      
      click_link 'Edit'
      save_and_open_page
      page.should have_content('Edit Project')
      
      
      visit projects_path(:customer_id => @cust.id)
      
      
      visit projects_path(:customer_id => @cust.id)
      
      
      visit projects_path(:customer_id => @cust.id)
      
      
      visit projects_path(:customer_id => @cust.id)     
      
    end
  end
end
