#
# Cookbook Name:: service_manager
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

dirlist=["/etc/nginx","/etc/nginx/conf.d" ]
  dirlist.each do |dir| 
        directory dir do
        mode "0755"
        action :create
  end
end

template "/etc/nginx/conf.d/sm.conf" do
    source "nginx.sm.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:backend_1],
      :upstream_2 => node[:propel_nginx][:backend_2],
      :upstream_1 => node[:propel_nginx][:backend_3],
      :upstream_2 => node[:propel_nginx][:backend_4],
    })
    only_if "node.chef_environment == 'env1' || node.chef_environment == 'prod'"
    notifies :restart, "service[nginx]", :immediately
end

template "/etc/nginx/conf.d/sm.conf" do
    source "nginx.sm.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:backend_1],
      :upstream_2 => node[:propel_nginx][:backend_2],
    })
    only_if "node.chef_environment == 'sandbox'"
    notifies :restart, "service[nginx]", :immediately
end