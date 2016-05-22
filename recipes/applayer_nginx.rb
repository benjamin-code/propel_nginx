#
# Cookbook Name:: propel_nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
service 'nginx' do
    service_name 'nginx'
  action [:enable, :start]
end

dirlist=["/etc/nginx","/etc/nginx/ssl","/etc/nginx/conf.d" ]
  dirlist.each do |dir| 
        directory dir do
        mode "0755"
        action :create
  end
end   

cookbook_file '/etc/nginx/ssl/propel_sandbox.crt' do
  source 'propel_sandbox.crt'
  mode '0755'
  only_if { node.chef_environment == 'sandbox' }
end
cookbook_file '/etc/nginx/ssl/propel_sandbox.key' do
  source 'propel_sandbox.key'
  mode '0755'
  only_if { node.chef_environment == 'sandbox' }
end

cookbook_file '/etc/nginx/ssl/propel_env1.crt' do
  source 'pln-cd1-ewebportal.core.eslabs.ssn.hp.com.crt'
  mode '0755'
  only_if { node.chef_environment == 'env1' }
end
cookbook_file '/etc/nginx/ssl/propel_env1.key' do
  source 'pln-cd1-ewebportal.core.eslabs.ssn.hp.com.key'
  mode '0755'
  only_if { node.chef_environment == 'env1' }
end

cookbook_file '/etc/nginx/ssl/propel_prod.crt' do
  source 'atcswa-cr-empp.mcloud.svcs.hpe.com.crt'
  mode '0755'
  only_if { node.chef_environment == 'prod' }
end
cookbook_file '/etc/nginx/ssl/propel_prod.key' do
  source 'atcswa-cr-empp.mcloud.svcs.hpe.com.key' 
  mode '0755'
  only_if { node.chef_environment == 'prod' }
end

template "/etc/nginx/conf.d/propel.conf" do
    source "applayer_nginx.sandbox.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_appserver_1],
      :upstream_2 => node[:propel_nginx][:propel_appserver_2],
      :crtfile => "/etc/nginx/ssl/propel_sandbox.crt",
      :keyfile => "/etc/nginx/ssl/propel_sandbox.key",
      :server_name => node.hostname
    })
     only_if { node.chef_environment == 'sandbox' }
     notifies :restart, "service[nginx]", :immediately
end


template "/etc/nginx/conf.d/propel.conf" do
    source "applayer_nginx.ft.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_appserver_1],
      :upstream_2 => node[:propel_nginx][:propel_appserver_2],
      :crtfile => "/etc/nginx/ssl/propel_env1.crt",
      :keyfile => "/etc/nginx/ssl/propel_env1.key",
      :server_name => node.hostname
    })
        only_if { node.chef_environment == 'env1' }
        notifies :restart, "service[nginx]", :immediately
end

template "/etc/nginx/conf.d/propel.conf" do
    source "applayer_nginx.pro.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_appserver_1],
      :upstream_2 => node[:propel_nginx][:propel_appserver_2],
      :upstream_3 => node[:propel_nginx][:propel_appserver_3],
      :upstream_4 => node[:propel_nginx][:propel_appserver_4],
      :crtfile => "/etc/nginx/ssl/propel_prod.crt",
      :keyfile => "/etc/nginx/ssl/propel_prod.key",
      :server_name => node.hostname
    })
     only_if { node.chef_environment == 'prod' }
     notifies :restart, "service[nginx]", :immediately
end

cookbook_file '/etc/logrotate.d/nginx' do
  source 'logrotate' 
  mode '0644'
  notifies :restart, "service[nginx]", :immediately
end