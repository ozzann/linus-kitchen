
# see https://gist.github.com/fgrehm/b07c6370a710be622807#file-02-ubuntu-vagrantfile-rb

%w{ lxc redir htop btrfs-tools apparmor-utils linux-image-generic linux-headers-generic }.each do |pkg|
  package pkg
end

bash "sudo aa-complain /usr/bin/lxc-start"

# XXX: should be installed per-project via bindler!
install_vagrant_plugin "vagrant-lxc", "0.5.0"

# TODO:
# * set VAGRANT_DEFAULT_PROVIDER=lxc
# * set alternate OMNIBUS_INSTALL_URL

# see https://github.com/fgrehm/vagrant-lxc/wiki/Avoiding-'sudo'-passwords
file "/usr/bin/lxc-vagrant-wrapper" do
  action :create
  owner "root"
  group "root"
  mode 00755
  content <<-EOH
#!/usr/bin/env ruby
exec ARGV.join(' ')
EOH
end
file "/etc/sudoers.d/vagrant-lxc" do
  action :create
  owner "root"
  group "root"
  mode 00644
  content <<-EOH
#{node['devbox']['user']} ALL=NOPASSWD:/usr/bin/lxc-vagrant-wrapper
EOH
end

