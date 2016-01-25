#
# Cookbook Name:: propel_nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

#cookbook_file '/etc/yum.repos.d/nginx.repo' do
#  source 'nginx.repo'
#  mode '0644'
#end

#yum_package 'nginx' do
#  action :install
#  flush_cache [ :before ]
#end

service 'nginx' do
    service_name 'nginx'
  action [:enable, :start]
end

#Generate certificate for nginx reserve proxy

dirlist=["/etc/nginx","/etc/nginx/ssl","/etc/nginx/conf.d" ]
  dirlist.each do |dir| 
        directory dir do
        mode "0755"
        action :create
  end
end   

if node.hostname == node[:propel_nginx][:nginx_for_ui]
  include_recipe "propel_nginx::nginx_lb"
end

if node.hostname == node[:propel_nginx][:nginx_ha_master]
  include_recipe "propel_nginx::nginx_ha"
end

if node.hostname == node[:propel_nginx][:nginx_ha_backup]
  include_recipe "propel_nginx::nginx_ha"
end