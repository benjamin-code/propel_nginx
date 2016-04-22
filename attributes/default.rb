if node.chef_environment == 'sandbox'
default[:service_manager][:backend_1] = "30.160.245.220"
default[:service_manager][:backend_2] = "30.160.245.224"
default[:service_manager][:sqldb_url] = "30.160.245.226:1521/orcl"
default[:service_manager][:sm_media_url] = "30.160.245.213"
default[:service_manager][:keystore_path]] = "/root/.keystore"
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

default[:service_manager][:password] = "smSpring11"
