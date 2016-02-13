bash 'configure_nginx_app_iptables' do
  code <<-EOH
    for port in 8089 9000 9010 9100 9200 9300 9400 9410 9500 9700 9800 9600 9444; do
    if iptables -L -n | grep -n "dpt.*${port}"
      then
        echo "existed rule."; 
      else 
        iptables -I INPUT -p tcp -m tcp --dport ${port} -j ACCEPT
      fi;
    done
    
    service iptables save
    EOH
	only_if 'service iptables status'
end