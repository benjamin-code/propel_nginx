if node.chef_environment == 'sandbox'
  service 'iptables' do
      service_name 'iptables'
    action :stop
  end
end

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

