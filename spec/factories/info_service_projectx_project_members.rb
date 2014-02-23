# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :info_service_projectx_project_member, :class => 'InfoServiceProjectx::ProjectMember' do
    project_id 1
    user_id 1
    active true
    active_end_date "2014-02-16"
    project_role_lead false
    project_role_id 1
    brief_note "MyText"
  end
end
