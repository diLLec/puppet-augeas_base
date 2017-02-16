class { '::augeas_base':
  default_lens => 'Sshd.lns',
}->
augeas_base::settings_to_file { '/etc/ssh/sshd_config_test':
  settings => {
    'Port'    => '23',
  },
}
