#
# Cookbook Name:: propel_nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#  
template "/etc/nginx/conf.d/default.conf" do
    source "nginx.backend.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_backend_1],
      :upstream_2 => node[:propel_nginx][:propel_backend_2],
      :server_name => node.hostname
    })
      notifies :run, "bash[Generate-certificate]"
      notifies :restart, "service[nginx]"
end

bash "Generate-certificate" do
    cwd "/etc/nginx/ssl"
    action  :nothing
    code <<-EOH
        openssl genrsa -out CA.key 2048 -des3
        openssl req -x509 -sha256 -new -nodes -key CA.key -days 365 -out CA.crt -subj "/CN=Generated Propel CA"
        openssl genrsa -des3 -passout "pass:propel2014" -out private.key.pem 2048
        openssl req -new -sha256 -passin "pass:propel2014" -subj "/CN=#{node.fqdn}" -key private.key.pem -out propel_host.key.csr
        openssl rsa -passin "pass:propel2014" -in private.key.pem -out propel_host.key.rsa
        openssl x509 -req -sha256 -in propel_host.key.csr -CA CA.crt -CAkey CA.key -CAcreateserial -days 365 > propel_host.crt
    EOH
end

#Configure nginx configuration file for reserve proxy
if node.hostname == node[:propel_nginx][:nginx_ha_master]
    priority = 100
    state = "MASTER"
end

if node.hostname == node[:propel_nginx][:nginx_ha_backup]
     priority = 90
     state = "BACKUP"
end

yum_package 'keepalived' do
  action :install
  flush_cache [ :before ]
end

service 'keepalived' do
    service_name 'keepalived'
  action [:enable, :start]
end

template "/etc/keepalived/keepalived.conf" do
   source "keepalived.conf"
   variables ({
#    :server_name => node.hostname
    :router_id => node.hostname,
    :priority => priority,
    :vip => node[:propel_nginx][:vip],
    :state => state
    }) 
          notifies :restart, "service[keepalived]" 
end

cookbook_file '/etc/keepalived/check-nginx.sh' do
   source 'check-nginx.sh'
   mode '0755'
   action :create_if_missing
  end