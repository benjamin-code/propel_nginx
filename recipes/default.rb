#
# Cookbook Name:: service_manager
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

#Install and configure SM
include_recipe "service_manager::install-cfg-sm"

#Deploy webtier
include_recipe "service_manager::deploy-webtier"

#Config Nginx
include_recipe "service_manager::nginx"

