#
# Cookbook Name:: propel_nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

#Configure nginx configuration file for reserve proxy
template "/etc/nginx/conf.d/default.conf" do
   source "nginx.ui.conf.erb"
   variables ({
     :upstream_1 => node[:propel_nginx][:propel_ui_1],
     :upstream_2 => node[:propel_nginx][:propel_ui_2],
     :server_name => node.hostname
   })
     notifies :run, "bash[Generate-certificate]", :immediately
     notifies :restart, "service[nginx]", :immediately
     notifies :run, 'ruby_block[SSL cert uploading]', :immediately

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

ruby_block "SSL cert uploading" do
  block do
    if File.exists?("/etc/nginx/ssl/propel_host.crt")
      f = File.open("/etc/nginx/ssl/propel_host.crt")
      node.normal["ssl_cert"] = f.read
      f.close
    end
  end
    action  :nothing
end