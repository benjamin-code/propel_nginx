if node.chef_environment == 'prod'
default[:propel_nginx][:propel_backend_1] = "atc-cr-wls3"
default[:propel_nginx][:propel_backend_2] = "atc-cr-wls4"
default[:propel_nginx][:propel_backend_3] = "swa-cr-wls3"
default[:propel_nginx][:propel_backend_4] = "swa-cr-wls4"
default[:propel_nginx][:propel_nginx_vip] = "atcswa-cr-atlassian.ecs-core.ssn.hp.com"
end

if node.chef_environment == 'sandbox'
default[:propel_nginx][:propel_backend_1] = "atc-cr-wls3"
default[:propel_nginx][:propel_backend_2] = "atc-cr-wls4"
default[:propel_nginx][:propel_backend_3] = "swa-cr-wls3"
default[:propel_nginx][:propel_backend_4] = "swa-cr-wls4"
default[:propel_nginx][:propel_nginx_vip] = "nginxvip.hp.com"
end

if node.chef_environment == 'env1'
default[:propel_nginx][:propel_backend_1] = "atc-cr-wls3"
default[:propel_nginx][:propel_backend_2] = "atc-cr-wls4"
default[:propel_nginx][:propel_backend_3] = "swa-cr-wls3"
default[:propel_nginx][:propel_backend_4] = "swa-cr-wls4"
default[:propel_nginx][:propel_nginx_vip] = "pln-cd1-apigw-vip.core.eslabs.ssn.hp.com"
end
