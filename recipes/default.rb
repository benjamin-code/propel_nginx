#
# Cookbook Name:: propel_nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

include_recipe "propel_nginx::applayer_iptables"
include_recipe "propel_nginx::applayer_nginx"
