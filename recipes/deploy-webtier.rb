#
# Cookbook Name:: service_manager
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
keystore_path  = node[:service_manager][:keystore_path]

cookbook_file keystore_path do
  source '.keystore'
  mode '0755'
end

cookbook_file '/opt/HP/ServiceManager9.40/Server/apache-tomcat-8.0.33.tar.gz' do
  source 'apache-tomcat-8.0.33.tar.gz'
  mode '0755'
  notifies :run, "bash[Unzip apache-tomcat-8.0.33.tar.gz]", :immediately
end

bash "Unzip apache-tomcat-8.0.33.tar.gz" do
    cwd '/opt/HP/ServiceManager9.40/Server'
  code <<-EOH
         tar xzf /opt/HP/ServiceManager9.40/Server/apache-tomcat-8.0.33.tar.gz
    EOH
end

template '/opt/HP/ServiceManager9.40/Server/apache-tomcat-8.0.33/conf/server.xml' do
  source 'server.xml'
  mode '0755'
  variables ({
      :keystore_path => keystore_path
    })
  notifies :run, "bash[start tomcat]", :immediately
end

bash "start tomcat" do
  user 'root'
  code <<-EOH
         /opt/HP/ServiceManager9.40/Server/apache-tomcat-8.0.33/bin/startup.sh
    EOH
end