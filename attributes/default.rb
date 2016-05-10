default[:propel_nginx][:image_service_port] = 8662
default[:propel_nginx][:image_service_path] = '/propel-api/imgsvcs'
default[:propel_nginx][:propelapi_port] = 8844

if node.chef_environment == 'prod'
default[:propel_nginx][:propel_backend_1] = "atc-cr-wls3"
default[:propel_nginx][:propel_backend_2] = "atc-cr-wls4"
default[:propel_nginx][:propel_backend_3] = "swa-cr-wls3"
default[:propel_nginx][:propel_backend_4] = "swa-cr-wls4"
default[:propel_nginx][:propel_nginx_vip] = "atcswa-cr-atlassian.ecs-core.ssn.hp.com"
default[:propel_nginx][:propel_cert_path] = "/etc/nginx/ssl/propel_prod.crt"
default[:propel_nginx][:propel_key_path] = "/etc/nginx/ssl/propel_prod.key"
end

if node.chef_environment == 'sandbox'
default[:propel_nginx][:propel_backend_1] = "propel-ha-5"
default[:propel_nginx][:propel_backend_2] = "propel-ha-6"
default[:propel_nginx][:propel_nginx_vip] = "nginxvip.hp.com"
default[:propel_nginx][:propel_cert_path] = "/etc/nginx/ssl/propel_sandbox.crt"
default[:propel_nginx][:propel_key_path] = "/etc/nginx/ssl/propel_sandbox.key"
end

if node['fqdn'] == 'c4t12189.itcs.hpecorp.net'
    default[:propel_nginx][:propel_backend_1] = "c4t12190.itcs.hpecorp.net"
    default[:propel_nginx][:propel_cert_path] = "/etc/ssl/certs/portlet_nginx.crt"  # portlet_proxy will install this cert
    default[:propel_nginx][:propel_nginx_vip] = nil
    default[:propel_nginx][:propel_key_path] = "/etc/ssl/certs/portlet_nginx.key"   # portlet_proxy will install this key
end

if node.chef_environment == 'env1'
default[:propel_nginx][:propel_backend_1] = "pln-cd1-iweb3"
default[:propel_nginx][:propel_backend_2] = "pln-cd1-iweb4"
default[:propel_nginx][:propel_nginx_vip] = "pln-cd1-apigw-vip.core.eslabs.ssn.hp.com"
default[:propel_nginx][:propel_cert_path] = "/etc/nginx/ssl/propel_env1.crt"
default[:propel_nginx][:propel_key_path] = "/etc/nginx/ssl/propel_env1.key"
end
