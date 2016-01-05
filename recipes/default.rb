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

#Configure nginx configuration file for reserve proxy
if node.ipaddress == node[:propel_nginx][:nginx_for_ui]
  template "/etc/nginx/conf.d/default.conf" do
    source "nginx.ui.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_ui_1],
      :upstream_2 => node[:propel_nginx][:propel_ui_2],
      :server_name => node.hostname
    })
  end

cookbook_file '/etc/nginx/ssl-propel-ha-1.tar.gz' do
   source 'ssl-propel-ha-1.tar.gz'
   mode '0755'
  end
execute "Extract ssl" do
   user "root"
   cwd  "/etc/nginx"
   command "tar zxf ssl-propel-ha-1.tar.gz"
end
    priority = 100
    state = "MASTER"
end


if node.ipaddress == node[:propel_nginx][:nginx_for_backend]
  template "/etc/nginx/conf.d/default.conf" do
    source "nginx.backend.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_backend_1],
      :upstream_2 => node[:propel_nginx][:propel_backend_2],
      :server_name => node.hostname
    })
  #  notifies :restart, "service[mule]", :immediately
  end
    cookbook_file '/etc/nginx/ssl-propel-ha-2.tar.gz' do
   source 'ssl-propel-ha-2.tar.gz'
   mode '0755'
  end
execute "Extract ssl" do
   user "root"
   cwd  "/etc/nginx"
   command "tar zxf ssl-propel-ha-2.tar.gz"
end
     priority = 90
     state = "BACKUP"
end

#Restart nginx to take configuration effect.
execute "restart_nginx" do
   user "root"
   command "nginx -s quit & nginx"
end

yum_package 'keepalived' do
  action :install
  flush_cache [ :before ]
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
end

cookbook_file '/etc/keepalived/check-nginx.sh' do
   source 'check-nginx.sh'
   mode '0755'
#   notifies :restart, "service[keepalived]", :immediately 
  end

execute "Restart keepalived" do
   user "root"
   command "service keepalived restart"
end