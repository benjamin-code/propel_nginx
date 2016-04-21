if node.chef_environment == 'sandbox'
default[:service_manager][:backend_1] = ""
default[:service_manager][:backend_2] = ""
default[:service_manager][:backend_3] = ""
default[:service_manager][:backend_4] = ""
default[:service_manager][:sqldb] = "30.160.245.226:1521/orcl"
default[:service_manager][:sm_media_url] = "30.160.245.224"
end

if node.chef_environment == 'env1'
default[:service_manager][:backend_1] = ""
default[:service_manager][:backend_2] = ""
default[:service_manager][:backend_3] = ""
default[:service_manager][:backend_4] = ""
default[:service_manager][:sqldb] = ""
default[:service_manager][:sm_media_url] = ""
end

if node.chef_environment == 'prod'
default[:service_manager][:backend_1] = ""
default[:service_manager][:backend_2] = ""
default[:service_manager][:backend_3] = ""
default[:service_manager][:backend_4] = ""
default[:service_manager][:sqldb] = ""
default[:service_manager][:sm_media_url] = ""
end