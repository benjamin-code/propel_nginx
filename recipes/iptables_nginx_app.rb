bash 'configure_nginx_app_iptables' do
  code <<-EOH
    for port in 9595 9510 9444 9810 8449 9040 9600 8000 8001 8002 9843 9530 9050; do
    if iptables -L -n | grep -n "dpt.*${port}"
      then
        echo "port ${port} already exists in iptables."; 
      else 
        iptables -I INPUT -p tcp -m tcp --dport ${port} -j ACCEPT
      fi;
    done
    
    service iptables save
    EOH
	only_if 'service iptables status'
end