augeas_base::settings_to_file { '/etc/puppetlabs/puppet/puppet_test.conf':
  settings => {
    'main/certname' => 'agent01.example.com',
    'main/server'   => 'master.example.com',
    'agent/report'  => 'true',
    'master/dns_alt_names' => 'master,master.example.com,puppet,puppet.example.com'
  },
}