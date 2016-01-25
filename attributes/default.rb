if ( node.hostname =~ /atc(.*)/ )
  puts "This is the Prod environment."
#default[:propel_nginx][:nginx_for_ui] = ""
default[:propel_nginx][:nginx_ha_master] = "atc-cr-iweb6"
default[:propel_nginx][:nginx_ha_backup] = "atc-cr-iweb7"
default[:propel_nginx][:propel_ui_1] = "propel-ha-3"
default[:propel_nginx][:propel_ui_2] = "propel-ha-4"
default[:propel_nginx][:propel_backend_1] = "propel-ha-3"
default[:propel_nginx][:propel_backend_2] = "propel-ha-4"
#default[:propel_nginx][:vip] = "30.161.224.210/24" #Need to set VIP of Prod env..
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
default[:propel_nginx][:vip] = "30.161.224.149"
end

if ( node.hostname =~ /pln(.*)/ )
  puts "This is the FT1 environment."
#default[:propel_nginx][:nginx_for_ui] = "propel-ha-1"
default[:propel_nginx][:nginx_ha_master] = "pln-cd1-iweb8"
default[:propel_nginx][:nginx_ha_backup] = "pln-cd1-iweb9"
default[:propel_nginx][:propel_ui_1] = "pln-cd1-eweb8"
default[:propel_nginx][:propel_ui_2] = "pln-cd1-eweb9"
default[:propel_nginx][:propel_backend_1] = "pln-cd1-iweb3"
default[:propel_nginx][:propel_backend_2] = "pln-cd1-iweb4"
#default[:propel_nginx][:vip] = "204.104.5.84"
end