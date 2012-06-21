# Install newrelic server monitoring

apt_repository "newrelic" do
  uri 'http://apt.newrelic.com/debian/'
  key 'http://download.newrelic.com/548C16BF.gpg'

  distribution "newrelic"
  components ['non-free']
  action :add
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
