# Install newrelic server monitoring

execute "Add newrelic apt source" do
  command "wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list"
  not_if { File.exist?('/etc/apt/sources.list.d/newrelic.list') }
end

execute "Add newrelic key to apt keyring" do
  command "apt-key adv --keyserver hkp://subkeys.pgp.net --recv-keys 548C16BF && apt-get update"
  not_if "gpg --keyring /etc/apt/trusted.gpg --list-keys | grep '1024D/548C16BF'"
end

package "newrelic-sysmond" do
  action :install
end

service "newrelic-sysmond" do
  action :nothing
end

template "/etc/newrelic/nrsysmond.cfg" do
  source "nrsysmond.cfg.erb"
  owner 'root'
  group 'newrelic'
  mode '0640'
  notifies :restart, resources(:service => "newrelic-sysmond")
end
