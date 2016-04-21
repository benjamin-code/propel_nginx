#
# Cookbook Name:: service_manager
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

cookbook_file '/opt/HP/ServiceManager9.40/Server/apache-tomcat-8.0.33.tar.gz' do
  source 'apache-tomcat-8.0.33.tar.gz'
  mode '0755'
  notifies :run, "bash[Unzip apache-tomcat-8.0.33.tar.gz]", :immediately
end

bash "Unzip apache-tomcat-8.0.33.tar.gz" do
    cwd /opt/HP/ServiceManager9.40/Server
  code <<-EOH
         tar xzf /opt/HP/ServiceManager9.40/Server/apache-tomcat-8.0.33.tar.gz
    EOH
end