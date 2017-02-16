# Vagrantfile for augeas_base
#  note that environment variables need to be passed to vagrant up/provision

Vagrant.configure('2') do |config|
  config.vm.box = 'bento/centos-7.2'

  config.vm.hostname = 'puppet-module-augeas-base'
  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.synced_folder '.', '/etc/puppet/modules/augeas_base', type: 'virtualbox'

  if ENV['http_proxy']
    if Vagrant.has_plugin?('vagrant-proxyconf')
      config.proxy.http     = ENV['http_proxy']
      config.proxy.https    = ENV['http_proxy']
      config.proxy.no_proxy = ENV['no_proxy']
    end
  end

  config.vm.provision 'shell' do |s|
    s.path = 'contrib/vagrant_bootstrap_before_puppet.sh'
  end

  config.librarian_puppet.puppetfile_dir = 'contrib/'
  # placeholder_filename defaults to .PLACEHOLDER
  config.librarian_puppet.placeholder_filename = '.keep'
  # config.librarian_puppet.use_v1_api  = '1' # Check https://github.com/voxpupuli/librarian-puppet#how-to-use
  config.librarian_puppet.destructive = false # Check https://github.com/voxpupuli/librarian-puppet#how-to-use
  config.vm.provision 'puppet' do |puppet|
    puppet.environment_path     = ''
    puppet.environment          = 'contrib'
    puppet.options              = '--debug --verbose'
    puppet.module_path          = 'contrib/modules'
  end

  config.vm.provision 'spec', type: 'shell', inline: 'cd /etc/puppet/modules/augeas_base && scl enable rh-ruby23 -- bundle exec rake spec'
end
