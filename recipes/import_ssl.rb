#Import ssl cert
cookbook_file '/tmp/ssl_crt.tar.gz' do
  source 'ssl_crt.tar.gz'
  mode '0755'
end

bash "import-ssl" do 
  cwd   '/tmp'
#  action :nothing
  code <<-EOH
      tar zxf /tmp/ssl_crt.tar.gz 
      keytool -importcert -file propel-ha-1.hp.com_propel_host.crt -keystore propel.truststore -alias "propel-ha-1.hp.com" -storepass "propel2014" -noprompt
      keytool -importcert -file propel-ha-2.hp.com_propel_host.crt -keystore propel.truststore -alias "propel-ha-2.hp.com" -storepass "propel2014" -noprompt
      EOH
end