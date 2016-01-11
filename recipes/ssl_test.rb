#Upload SSL cert to node attribute
ruby_block "SSL cert uploading" do
  block do
    if File.exists?("/etc/nginx/ssl/propel_host.crt")
      f = File.open("/etc/nginx/ssl/propel_host.crt")

      node.set["ssl_cert"] = f.read
                  puts f.read
      f.close
    end
  end
end