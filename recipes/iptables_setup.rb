#open firewall port for Nginx

execute "open firewall port for Nginx" do
  user "root"
  command <<-EOH		
			 iptables -I INPUT -p tcp -m tcp --dport ${port} -j ACCEPT
        EOH
  not_if "iptables -L -n | grep -n "dpt.*${port}""
  notifies :run, "execute[save iptables for ipam]", :immediately
end

execute "save iptables for ipam" do
   user "root"
   command "/sbin/service iptables save"
   action :nothing
end