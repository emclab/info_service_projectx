require "info_service_projectx/engine"

module InfoServiceProjectx
  mattr_accessor :customer_class #, :service_module_path, :support_module_path, :develop_mgmt_module_path, :customer_info_module_path, :ticket_module_path
  
  def self.customer_class
    @@customer_class.constantize
  end
end
