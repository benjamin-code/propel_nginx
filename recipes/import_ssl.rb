#Import ssl cert
cookbook_file '/tmp/ssl_crt.tar.gz' do
  source 'ssl_crt.tar.gz'
  mode '0755'
end

if ( node.ipaddress =~ /30.161(.*)/ )
  puts "This is the N1 environment"
	bash "import-ssl" do 
 	 cwd   '/tmp'
 	 code <<-EOH
      tar zxf /tmp/ssl_crt.tar.gz 
      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-1
      	then
      keytool -importcert -file /tmp/ssl_crt/propel-ha-1.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-1.hp.com" -storepass "propel2014" -noprompt
      fi
      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-2
      	then
      keytool -importcert -file /tmp/ssl_crt/propel-ha-2.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-2.hp.com" -storepass "propel2014" -noprompt
      fi
      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-1
      	then
      keytool -importcert -file /tmp/ssl_crt/propel-ha-9.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-9.hp.com" -storepass "propel2014" -noprompt
      fi
      EOH
	end
else
  puts "This is the Prod environment"
	bash "import-ssl" do 
 	 cwd   '/tmp'
 	 code <<-EOH
      tar zxf /tmp/ssl_crt.tar.gz 
 	  if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-1
      	then
      keytool -importcert -file /tmp/ssl_crt/propel-ha-1.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-1.hp.com" -storepass "propel2014" -noprompt
      fi
      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-2
      	then
      keytool -importcert -file /tmp/ssl_crt/propel-ha-2.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-2.hp.com" -storepass "propel2014" -noprompt
      fi
      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-1
      	then
      keytool -importcert -file /tmp/ssl_crt/propel-ha-9.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-9.hp.com" -storepass "propel2014" -noprompt
      fi
      EOH
	end
end

