
#Production variables:
default[:propel_nginx][:nginx_for_ui] = ""
default[:propel_nginx][:nginx_ha_master] = "atc-cr-iweb6"
default[:propel_nginx][:nginx_ha_backup] = "atc-cr-iweb7"
default[:propel_nginx][:propel_ui_1] = "propel-ha-3"
default[:propel_nginx][:propel_ui_2] = "propel-ha-4"
default[:propel_nginx][:propel_backend_1] = "propel-ha-3"
default[:propel_nginx][:propel_backend_2] = "propel-ha-4"
default[:propel_nginx][:vip] = "30.161.224.210/24" #Need to set VIP of Prod env..

if ( node.hostname =~ /centos6(.*)/ )
  puts "This is the test environment."
default[:propel_nginx][:nginx_for_ui] = ""
default[:propel_nginx][:nginx_ha_master] = "centos6-5"
default[:propel_nginx][:nginx_ha_backup] = "centos6-6"
default[:propel_nginx][:propel_ui_1] = "15.107.12.82"
default[:propel_nginx][:propel_ui_2] = "15.107.12.82"
default[:propel_nginx][:propel_backend_1] = "15.107.12.82"
default[:propel_nginx][:propel_backend_2] = "15.107.12.82"
default[:propel_nginx][:vip] = "15.107.13.122/24"
end

if ( node.hostname =~ /propel-ha(.*)/ )
  puts "This is the N1 environment."
default[:propel_nginx][:nginx_for_ui] = "propel-ha-1"
default[:propel_nginx][:nginx_ha_master] = "propel-ha-2"
default[:propel_nginx][:nginx_ha_backup] = "propel-ha-9"
default[:propel_nginx][:propel_ui_1] = "propel-ha-3"
default[:propel_nginx][:propel_ui_2] = "propel-ha-4"
default[:propel_nginx][:propel_backend_1] = "propel-ha-5"
default[:propel_nginx][:propel_backend_2] = "propel-ha-6"
default[:propel_nginx][:vip] = "30.161.224.149/24"
end

