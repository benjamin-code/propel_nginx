#
# Cookbook Name:: propel_nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

#template "/etc/yum.repos.d/propel.repo" do
#   source "propel.repo.erb"
#   mode "0755"   
#   variables({ :repo_url => node[:propel_nginx][:repo_url] })
#end

yum_package 'nginx' do
  action :install
  flush_cache [ :before ]
end

#Generate certificate for nginx reserve proxy

dirlist=["/etc/nginx","/etc/nginx/ssl","/etc/nginx/conf.d" ]
  dirlist.each do |dir| 
        directory dir do
        mode "0755"
        action :create
  end
end   

if node.ipaddress == node[:propel_nginx][:nginx_for_ui]
  include_recipe "propel_nginx::nginx_lb"
end

if node.ipaddress == node[:propel_nginx][:nginx_ha_master]
  include_recipe "propel_nginx::nginx_ha"
end

if node.ipaddress == node[:propel_nginx][:nginx_ha_backup]
  include_recipe "propel_nginx::nginx_ha"
end