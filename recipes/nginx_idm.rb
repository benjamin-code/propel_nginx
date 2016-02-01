service 'nginx' do
    service_name 'nginx'
  action [:enable, :start]
end

dirlist=["/etc/nginx","/etc/nginx/ssl","/etc/nginx/conf.d" ]
  dirlist.each do |dir| 
        directory dir do
        mode "0755"
        action :create
  end
end   

cookbook_file '/etc/nginx/ssl/propel_sandbox.crt' do
  source 'propel_sandbox.crt'
  mode '0755'
end
cookbook_file '/etc/nginx/ssl/propel_sandbox.key' do
  source 'propel_sandbox.key'
  mode '0755'
end

template "/etc/nginx/conf.d/propel.conf" do
    source "nginx-idm.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_nginx_vip],
      :cert_path => node[:propel_nginx][:propel_cert_path],
      :key_path => node[:propel_nginx][:propel_key_path],
      :server_name => node.hostname
    })
    notifies :restart, "service[nginx]", :immediately
end

