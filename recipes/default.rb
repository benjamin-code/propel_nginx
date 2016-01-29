#
# Cookbook Name:: propel_nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

#cookbook_file '/etc/yum.repos.d/nginx.repo' do
#  source 'nginx.repo'
#  mode '0644'
#end

#yum_package 'nginx' do
#  action :install
#  flush_cache [ :before ]
#end

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
      :server_name => node.hostname
    })
     only_if { node.hostname =~ /propel-ha(.*)/  }
     notifies :run, "bash[Generate-certificate]", :immediately
     notifies :restart, "service[nginx]", :immediately

end

bash "Generate-certificate" do
    cwd "/etc/nginx/ssl"
    action  :nothing
    code <<-EOH
        openssl genrsa -out CA.key 2048 -des3
        openssl req -x509 -sha256 -new -nodes -key CA.key -days 365 -out CA.crt -subj "/CN=Generated Propel CA"
        openssl genrsa -des3 -passout "pass:propel2014" -out private.key.pem 2048
        openssl req -new -sha256 -passin "pass:propel2014" -subj "/CN=#{node.fqdn}" -key private.key.pem -out propel_host.key.csr
        openssl rsa -passin "pass:propel2014" -in private.key.pem -out propel_host.key.rsa
        openssl x509 -req -sha256 -in propel_host.key.csr -CA CA.crt -CAkey CA.key -CAcreateserial -days 365 > propel_host.crt
    EOH
end

template "/etc/nginx/conf.d/propel.conf" do
    source "nginx.prod.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_backend_1],
      :upstream_2 => node[:propel_nginx][:propel_backend_2],
      :upstream_3 => node[:propel_nginx][:propel_backend_3],
      :upstream_4 => node[:propel_nginx][:propel_backend_4],
      :crtfile => "/etc/ssl/certs/portlet_nginx.crt",
      :keyfile => "/etc/ssl/certs/portlet_nginx.key",
      :server_name => node.hostname
    })
     only_if { node.hostname =~ /cr(.*)/  }
     notifies :restart, "service[nginx]", :immediately
end