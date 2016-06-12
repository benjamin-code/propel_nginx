#
# Cookbook Name:: propel_nginx
# Recipe:: default


package "haproxy" do
  action :install
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end


template "/etc/haproxy/haproxy.cfg" do
    source "haproxy.cfg.env1.erb"
    mode 0644
    variables ({
      :app_1 => node[:propel_nginx][:propel_appserver_1],
      :app_2 => node[:propel_nginx][:propel_appserver_2]
    })
        only_if { node.chef_environment == 'env1' }
        notifies :restart, "service[haproxy]", :immediately
end

template "/etc/haproxy/haproxy.cfg" do
    source "haproxy.cfg.erb"
    mode 0644
    variables ({
      :app_1 => node[:propel_nginx][:propel_appserver_1],
      :app_2 => node[:propel_nginx][:propel_appserver_2],
      :app_3 => node[:propel_nginx][:propel_appserver_3],
      :app_4 => node[:propel_nginx][:propel_appserver_4]
    })
     only_if { node.chef_environment == 'prod' }
     notifies :restart, "service[haproxy]", :immediately
end