#
# Cookbook Name:: service_manager
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

sm_media_url  = node[:service_manager][:sm_media_url]
password  = node[:service_manager][:password]

# create user
user smadmin do
  action   :create
  system   true
  uid      '4050'
  gid      '4050'
  shell    '/sbin/nologin'
  home     '/home/smadmin'
  password password
  supports :manage_home=>true
end

directory '/tmp/sm940_media' do
   owner username
   group groupname
   mode "0755"
   action :create
end

cookbook_file '/tmp/sm940_media/installer.properties' do
  source 'installer.properties'
  mode '0755'
end

cookbook_file '/tmp/sm940_media/nss-softokn-freebl-3.12.9-11.el6.i686.rpm' do
  source 'nss-softokn-freebl-3.12.9-11.el6.i686.rpm'
  mode '0755'
  notifies :run, "bash[Install nss-softokn-freebl]", :immediately
end

bash "Install nss-softokn-freebl" do
    cwd '/tmp/sm940_media'
  code <<-EOH
         rpm -ivh /tmp/sm940_media/glibc-rpm/nss-softokn-freebl-3.12.9-11.el6.i686.rpm
    EOH
end

cookbook_file '/tmp/sm940_media/glibc-2.12-1.107.el6_4.5.i686.rpm' do
  source 'glibc-2.12-1.107.el6_4.5.i686.rpm'
  mode '0755'
  notifies :run, "bash[Install glibc]", :immediately
end

bash "Install glibc" do
    cwd '/tmp/sm940_media'
  code <<-EOH
         rpm -ivh /tmp/sm940_media/glibc-rpm/glibc-2.12-1.107.el6_4.5.i686.rpm
    EOH
end

remote_file "/tmp/sm940_media/oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm" do
      source 'http://#{sm_media_url}/oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm' 
      mode "0755"
      action  :create_if_missing
      notifies :run, "bash[Install-oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm]", :immediately
end

bash "Install-oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm" do
  code <<-EOH
         rpm -Uvh /tmp/sm940_media/oracle-instantclient11.2-basic-11.2.0.4.0-1.i386.rpm
    EOH
end

remote_file "/tmp/sm940_media/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm" do
      source 'http://#{sm_media_url}/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm' 
      mode "0755"
      action  :create_if_missing
      notifies :run, "bash[Install-oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm]", :immediately
end

bash "Install-oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm" do
  code <<-EOH
         rpm -Uvh /tmp/sm940_media/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.i386.rpm
    EOH
end

remote_file "/tmp/sm940_media/setupLinuxX64-sm940.bin" do
      source 'http://#{sm_media_url}/setupLinuxX64-sm940.bin' 
      mode "0755"
      action  :create_if_missing
      notifies :run, "bash[Install-sm]", :immediately
end

bash "Install-sm" do
  cwd '/tmp/sm940_media'
  code <<-EOH
         sh /tmp/sm940_media/setupLinuxX64-sm940.bin -i silent
    EOH
end

template "/opt/HP/ServiceManager9.40/Server/RUN/sm.ini" do
    source "sm.ini.erb"
    mode '0755'
    variables ({
      :sqldb_url => node[:service_manager][:sqldb_url]
    })
    only_if { ::File.exist?("/opt/HP/ServiceManager9.40/Server/RUN/smstart") }
    notifies :run, "bash[start server manager]", :immediately
end

bash "start server manager" do
  user 'smadmin'
  code <<-EOH
        chown -R smadmin:smadmin /opt/HP/ServiceManager9.40
        /opt/HP/ServiceManager9.40/Server/RUN/smstart
    EOH
end

