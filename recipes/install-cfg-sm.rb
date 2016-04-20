#
# Cookbook Name:: service_manager
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

directory /tmp/sm940_media do
   owner username
   group groupname
   mode "0755"
   action :create
end

cookbook_file '/tmp/sm940_media/propel_sandbox.crt' do
  source 'installer.properties'
  mode '0755'
end

cookbook_file '/tmp/sm940_media/oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm' do
  source 'oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm'
  mode '0755'
  notifies :run, "bash[Install-oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm]", :immediately
end

bash "Install-oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm" do
  code <<-EOH
         rpm -Uvh /tmp/sm940_media/oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm
    EOH
end

cookbook_file '/tmp/sm940_media/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm' do
  source 'oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm'
  mode '0755'
  notifies :run, "bash[Install-oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm]", :immediately
end

bash "Install-oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm" do
  code <<-EOH
         rpm -Uvh /tmp/sm940_media/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm
    EOH
end

cookbook_file '/tmp/sm940_media/setupLinuxX64-sm940.bin' do
  source 'setupLinuxX64-sm940.bin'
  mode '0755'
  notifies :run, "bash[Install-sm]", :immediately
end

bash "Install-sm" do
  cwd /tmp/sm940_media
  code <<-EOH
         sh /tmp/sm940_media/setupLinuxX64-sm940.bin -i silent
    EOH
end

cookbook_file '/opt/HP/ServiceManager9.40/Server/RUN/sm.ini' do
  source 'sm.ini'
  mode '0755'
  only_if { ::File.exist?("/opt/HP/ServiceManager9.40/Server/RUN/smstart") }
  notifies :run, "bash[start server manager]", :immediately
end

bash "start server manager" do
  code <<-EOH
         /opt/HP/ServiceManager9.40/Server/RUN/smstart
    EOH
end