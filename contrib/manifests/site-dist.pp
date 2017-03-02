class { '::augeas_base':
  default_lens => 'Sshd.lns',
  default_owner => 'root'
}->
augeas_base::dirsettings_to_file { '/etc/ssh/sshd_config_test':
  dirsettings => {
    'ChrootDirectory' => '/tmp/myssh'
  },
  filesettings => {
    'HostKey' => '/etc/ssh/ssh_host_key',
    'HostCertificate' => '/etc/pki/tls/cert.pem',
    'PidFile' => '/var/run/mysshd.pid'
  },
}