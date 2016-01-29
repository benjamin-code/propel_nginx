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

#Generate certificate for nginx reserve proxy

dirlist=["/etc/nginx","/etc/nginx/ssl","/etc/nginx/conf.d" ]
  dirlist.each do |dir| 
        directory dir do
        mode "0755"
        action :create
  end
end   

template "/etc/nginx/conf.d/propel.conf" do
    source "nginx.n1.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_backend_1],
      :upstream_2 => node[:propel_nginx][:propel_backend_2],
      :crtfile => "/etc/ssl/certs/portlet_nginx.crt"
      :keyfile => "/etc/ssl/certs/portlet_nginx.key"
      :server_name => node.hostname
    })
     only_if { node.hostname =~ /propel-ha(.*)/  }
     notifies :restart, "service[nginx]", :immediately
end

template "/etc/nginx/conf.d/propel.conf" do
    source "nginx.prod.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_backend_1],
      :upstream_2 => node[:propel_nginx][:propel_backend_2],
      :upstream_3 => node[:propel_nginx][:propel_backend_3],
      :upstream_4 => node[:propel_nginx][:propel_backend_4],
      :server_name => node.hostname
    })
     only_if { node.hostname =~ /cr(.*)/  }
     notifies :restart, "service[nginx]", :immediately
end
