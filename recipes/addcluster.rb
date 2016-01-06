
#Configure nginx configuration file for reserve proxy
if server_name == propel_backend_2
  template "/tmp/add_cluster.sh" do
    source "add_cluster.sh"
    mode '0755'
    variables ({
      :clustermaster => propel_backend_1_name,
    })
  end
#enable rabbitmq management plugin in node1
  execute "add_cluster" do
    user "root"
    command "/tmp/add_cluster.sh"
  end
end

