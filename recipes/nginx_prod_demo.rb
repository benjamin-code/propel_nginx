#
# Cookbook Name:: propel_nginx
# Recipe:: nginx_prod_demo
#
# This recipe will install Nginx for Propel PROD Demo.
# All UI + IDM ports will be forwarded to the single propel node.
# Copyright 2016, HPE
#
# All rights reserved - Do Not Redistribute
#
#

include_recipe "propel_nginx::iptables_nginx_prod_demo"

package 'nginx'  do
  action :install
  notifies :restart, "service[nginx]", :delayed
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
end

template "/etc/nginx/nginx.conf" do
  source "nginx.prod_demo.main.conf.erb"
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, "service[nginx]", :delayed
end

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

cookbook_file '/etc/nginx/ssl/propel_prod_demo.crt' do
  source 'atcswa-cr-propel.ecs-core.ssn.hp.com.crt'
  mode '0755'
end

cookbook_file '/etc/nginx/ssl/propel_prod_demo.key' do
  source 'atcswa-cr-propel.ecs-core.ssn.hp.com.key' 
  mode '0755'
end


template "/etc/nginx/conf.d/propel.conf" do
  source "nginx.prod_demo.conf.erb"
    variables ({
      :upstream_1 => "atc-cr-propel",
      :crtfile => "/etc/nginx/ssl/propel_prod_demo.crt",
      :keyfile => "/etc/nginx/ssl/propel_prod_demo.key",
      :server_name => node.hostname
    })
     notifies :restart, "service[nginx]", :delayed
end