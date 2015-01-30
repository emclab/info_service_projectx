require_dependency "info_service_projectx/application_controller"

module InfoServiceProjectx
  class ProjectsController < ApplicationController
    #before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Projects')
      @projects =  params[:info_service_projectx_projects][:model_ar_r]
      @projects = @projects.where(:customer_id => @customer.id) if @customer
      @projects = @projects.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('project_index_view', 'info_service_projectx')
    end

    def new
      @title = t('New Project')
      @project = InfoServiceProjectx::Project.new
      @erb_code = find_config_const('project_new_view', 'info_service_projectx')
    end


    def create
      @project = InfoServiceProjectx::Project.new(params[:project], :as => :role_new)
      @project.last_updated_by_id = session[:user_id]
      if @project.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('project_new_view', 'info_service_projectx')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Project')
      @project = InfoServiceProjectx::Project.find_by_id(params[:id])
      @erb_code = find_config_const('project_edit_view', 'info_service_projectx')
    end

    def update
        @project = InfoServiceProjectx::Project.find_by_id(params[:id])
        @project.last_updated_by_id = session[:user_id]
        if @project.update_attributes(params[:project], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('project_edit_view', 'info_service_projectx')
          render 'edit'
        end
    end

    def show
      @title = t('Project Info')
      @project = InfoServiceProjectx::Project.find_by_id(params[:id])
      @erb_code = find_config_const('project_show_view', 'info_service_projectx')
    end
    
    def index_for_customer
      @title = t('Projects')
      @projects =  params[:info_service_projectx_projects][:model_ar_r]
      @projects = @projects.where(:customer_id => session[:session_customer_id])
      @projects = @projects.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('project_index_for_customer_view', 'info_service_projectx')
    end
    
    def engine_for_config_check
      @title = t('Select Engines for Check')
      @project_id = params[:project_id].to_i
      @project = InfoServiceProjectx::Project.find_by_id(params[:project_id])
      engine_ids = ResourceAllocx::Allocation.where('resource_id = ? AND resource_string = ? AND detailed_resource_category = ?', @project.id, params[:controller],  'engine' ).order('name').pluck('detailed_resource_id')
      @engines = OnboardDataUploadx.engine_class.where(active: true).where(:id => engine_ids).order('id')
      @erb_code = find_config_const('project_engine_for_config_check_view', 'info_service_projectx')
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Select engine(s) for check") if @engines.blank?
    end
    
    def list_config_argument
      project_id = params[:save].keys[0]
      project = InfoServiceProjectx::Project.find_by_id(project_id)
      engine_ids_array = params[:id_array]
      @project_config_arguments = check_engine_config(project, engine_ids_array)
      @erb_code = find_config_const('project_list_config_argument_view', 'info_service_projectx')
    end
    
    def engine_for_access_check
      @title = t('Select Engines for Access Check')
      @project_id = params[:project_id].to_i
      @project = InfoServiceProjectx::Project.find_by_id(params[:project_id])
      engine_ids = ResourceAllocx::Allocation.where('resource_id = ? AND resource_string = ? AND detailed_resource_category = ?', @project.id, params[:controller],  'engine' ).pluck('detailed_resource_id') #if @project_id #engine_id
      @engines = OnboardDataUploadx.engine_class.where(active: true).where(:id => engine_ids).order('name')
      @roles = OnboardDataUploadx.project_misc_definition_class.where(:project_id => @project_id).where(:definition_category => 'role_definition').order('ranking_index')
      @erb_code = find_config_const('project_engine_for_access_check_view', 'info_service_projectx')
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Select engine(s) for access check") if @engines.blank?
    end
    
    def list_user_access
      project_id = params[:save].keys[0]
      project = OnboardDataUploadx.project_class.find_by_id(project_id)
      engine_ids_array, role_ids = return_engine_n_role(params[:id_array])
      @project_user_accesses = check_user_access(project, engine_ids_array, role_ids)
      @erb_code = find_config_const('project_list_user_access_view', 'info_service_projectx')
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Select access for onboard") if engine_ids_array.blank?
    end
    
    protected
    def load_parent_record
      @customer = InfoServiceProjectx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @customer = InfoServiceProjectx.customer_class.find_by_id(InfoServiceProjectx::Project.find_by_id(params[:id])) if params[:id].present?
    end
    
    def check_engine_config(project, engine_ids)
      output_string = project.name + "\n"+"\n"
      engine_ids.each do |e_id|
        engine_name = InfoServiceProjectx.module_info_class.find_by_id(e_id).name 
        onboarded_arguments = OnboardDatax::OnboardEngineConfig.joins(:engine_config).where('onboard_datax_onboard_engine_configs.engine_id = ? AND onboard_datax_onboard_engine_configs.project_id = ?', e_id, project.id).order('argument_name').pluck('argument_name')
        output_string += "\n" +"\n" + "\n" +"\n" + '=============' + "#{engine_name}" + '===============' + "\n" + "\n" + "Onboarded Arguments" + "\n" + "\n"
        onboarded_arguments.each do |arg|
          output_string += arg + "\n"
        end
        engine_arguments_not_onboarded = OnboardDataUploadx::EngineConfig.where('onboard_data_uploadx_engine_configs.engine_id = ?', e_id).where('onboard_data_uploadx_engine_configs.argument_name NOT IN (?)', onboarded_arguments).order('argument_name').pluck('argument_name').uniq()
        output_string += "\n" +"\n" + "Arguments - NOT Onboarded" + "\n" + "\n"
        engine_arguments_not_onboarded.each do |e_arg|
          output_string += e_arg + "\n"
        end
      end
      output_string
    end
    
    def check_user_access(project, engine_ids, role_ids)
      output_string = project.name + "\n"+"\n"
      engine_ids.each do |e_id|
        engine_name = InfoServiceProjectx.module_info_class.find_by_id(e_id).name 
        onboarded_accesses_obj = OnboardDatax::OnboardUserAccess.joins(:user_access).where('onboard_datax_onboard_user_accesses.engine_id = ? AND onboard_datax_onboard_user_accesses.project_id = ? AND onboard_datax_onboard_user_accesses.role_definition_id IN (?)', 
                                e_id, project.id, role_ids).order('onboard_data_uploadx_user_accesses.resource, onboard_data_uploadx_user_accesses.action')
        onboarded_user_access_ids = onboarded_accesses_obj.pluck('onboard_datax_onboard_user_accesses.id')
        onboarded_actions = onboarded_accesses_obj.pluck('onboard_data_uploadx_user_accesses.action')
        output_string += "\n" +"\n" + "\n" +"\n" + '=============' + "#{engine_name}" + '===============' + "\n" + "\n" + "Onboarded User Access" + "\n" + "\n"
        onboarded_user_access_ids.each do |id|
          ua = OnboardDataUploadx::UserAccess.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(id).user_access_id)
          role = ProjectMiscDefinitionx::MiscDefinition.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(id).role_definition_id).name
          output_string += ua.resource + ',  ' + ua.action + ',  ' + role + ',  ' + ua.sql_code[0..255] + "\n" if ua.sql_code.present?
          output_string += ua.resource + ',  ' + ua.action + ',  ' + role + "\n" if ua.sql_code.blank?
        end
        user_access_not_onboarded = OnboardDataUploadx::UserAccess.where('onboard_data_uploadx_user_accesses.engine_id = ?', e_id).
                            where('onboard_data_uploadx_user_accesses.action NOT IN (?)', onboarded_actions).order('resource, action').uniq() 
        output_string += "\n" +"\n" + "User Access - NOT Onboarded" + "\n" + "\n"
        user_access_not_onboarded.each do |e_arg|
          output_string += e_arg.resource + ',  ' + e_arg.action + "\n"
        end
      end
      output_string
    end
    
    def return_engine_n_role(ids_array)
      engine_ids = []
      role_ids = []
      ids_array.each do |id|  #ids passed in as a string of 'user_access_id, role_id'
        id = id.split(',')
        engine_ids << id[0].to_i unless engine_ids.include?(id[0].to_i)
        role_ids << id[1].to_i unless role_ids.include?(id[1].to_i)
      end      
      return engine_ids, role_ids   #OnboardDataUploadx.project_misc_definition_class.where(:id => role_ids).order('ranking_index')
    end
    
  end
end
