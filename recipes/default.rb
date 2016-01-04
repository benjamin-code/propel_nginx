#
# Cookbook Name:: ecs_python
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

server_name = node.ipaddress
nginx_for_ui = node[:propel_nginx][:nginx_for_ui]
nginx_for_backend = node[:propel_nginx][:nginx_for_backend]
propel_ui_1 = node[:propel_nginx][:propel_ui_1]
propel_ui_2 = node[:propel_nginx][:propel_ui_2]
propel_backend_1 = node[:propel_nginx][:propel_backend_1]
propel_backend_2 = node[:propel_nginx][:propel_backend_2]

#Install Nginx via yum
cookbook_file '/etc/yum.repos.d/nginx.repo' do
  source 'nginx.repo'
  mode '0755'
end

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
if server_name == nginx_for_ui
  template "/etc/nginx/conf.d/default.conf" do
    source "nginx.ui.conf.erb"
    #owner username
    #group groupname
    variables ({
      :upstream_1 => propel_ui_1,
      :upstream_2 => propel_ui_2,
      :server_name => server_name
    })
  #  notifies :restart, "service[mule]", :immediately
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
end


if server_name == nginx_for_backend
  template "/etc/nginx/conf.d/default.conf" do
    source "nginx.backend.conf.erb"
    #owner username
    #group groupname
    variables ({
      :upstream_1 => propel_backend_1,
      :upstream_2 => propel_backend_2,
      :server_name => server_name
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
end

#Restart nginx to take configuration effect.
execute "restart_nginx" do
   user "root"
   command "nginx -s quit & nginx"
end