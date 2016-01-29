if ( node.hostname =~ /cr(.*)/ )
  puts "This is the Prod environment."
default[:propel_nginx][:propel_backend_1] = "act-cr-wls3"
default[:propel_nginx][:propel_backend_2] = "act-cr-wls4"
default[:propel_nginx][:propel_backend_3] = "swa-cr-wls3"
default[:propel_nginx][:propel_backend_4] = "swa-cr-wls4"
end

if ( node.hostname =~ /propel-ha(.*)/ )
  puts "This is the N1 environment."
default[:propel_nginx][:propel_backend_1] = "propel-ha-5"
default[:propel_nginx][:propel_backend_2] = "propel-ha-6"
end

if ( node.hostname =~ /pln(.*)/ )
  puts "This is the FT1 environment."
default[:propel_nginx][:propel_backend_1] = "pln-cd1-iweb3"
default[:propel_nginx][:propel_backend_2] = "pln-cd1-iweb4"
end