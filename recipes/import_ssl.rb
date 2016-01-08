#Import ssl cert
cookbook_file '/tmp/ssl_crt.tar.gz' do
  source 'ssl_crt.tar.gz'
  mode '0755'
end

if ( node.hostname =~ /propel-ha(.*)/ )
  puts "This is the N1 environment"
	bash "import-ssl" do 
 	 cwd   '/tmp'
 	 code <<-EOH
      tar zxf /tmp/ssl_crt.tar.gz 
      nodes=("propel-ha-1" "propel-ha-2" "propel-ha-5" "propel-ha-6" "propel-ha-9" )
      for i in {0..4}
        do
          if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q ${nodes[$i]}
          then
            keytool -importcert -file /tmp/ssl_crt/${nodes[$i]}.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "${nodes[$i]}.hp.com" -storepass "propel2014" -noprompt
          fi
      done
      EOH
	end
end

if ( node.hostname =~ /atc(.*)/ )
  puts "This is the Prod environment"
	bash "import-ssl" do 
 	 cwd   '/tmp'
 	 code <<-EOH
      tar zxf /tmp/ssl_crt.tar.gz 
      nodes=("propel-ha-1" "atc-cr-iweb6" "atc-cr-iweb7" "propel-ha-4" "atc-cr-wls5" "atc-cr-wls6" )
      for i in {0..9}
        do
          if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q ${nodes[$i]}
          then
            keytool -importcert -file /tmp/ssl_crt/${nodes[$i]}_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "${nodes[$i]}" -storepass "propel2014" -noprompt
          fi
      done
      EOH
	end
end

if ( node.hostname =~ /centos6(.*)/ )
  puts "This is the Prod environment"
  bash "import-ssl" do 
   cwd   '/tmp'
   code <<-EOH
      tar zxf /tmp/ssl_crt.tar.gz 
      nodes=("centos6-5" "centos6-6" )
      for i in {0..1}
        do
          if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q ${nodes[$i]}
          then
            keytool -importcert -file /tmp/ssl_crt/${nodes[$i]}_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "${nodes[$i]}" -storepass "propel2014" -noprompt
          fi
      done
      EOH
  end
end