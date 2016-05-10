

MONITOR_FILE="/usr/share/nginx/html/monitor-propelapi.html"

template MONITOR_FILE do
    source "monitor-propelapi.html.erb"
    variables({
      :hostname  => node['fqdn'],
      :status => "Server Up",
      :port => node[:propel_nginx][:propelapi_port]
   })
  action :create
end

template "/etc/nginx/conf.d/propelapi.conf" do
    source "propelapi.conf.erb"
    variables ({
      :upstream_1 => node[:propel_nginx][:propel_backend_1],
      :cert_path => node[:propel_nginx][:propel_cert_path],
      :key_path => node[:propel_nginx][:propel_key_path],
      :image_service_path => node[:propel_nginx][:image_service_path],
      :image_service_port => node[:propel_nginx][:image_service_port],
      :server_name => node.hostname,
      :monitor_file => MONITOR_FILE,
      :propelapi_port => node[:propel_nginx][:propelapi_port]
    })
    notifies :restart, "service[nginx]", :delayed
end

cookbook_file '/etc/logrotate.d/nginx' do
  source 'logrotate'
  mode '0644'
  notifies :restart, "service[nginx]", :delayed
end

service 'nginx' do
  supports :status => true
  action :start
end