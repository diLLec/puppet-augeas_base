# A define to use augeas to put a hash of settings into a file
#
# @example using the define
#   augeas_base::settings_to_file { '/etc/ssh/sshd_config':
#     settings => {
#       'Port' => '23',
#       'HostKey' => '/etc/ssh/ssh_host_key'
#     }
#   }
#
#   augeas_base::settings_to_file { '/etc/php.ini':
#      settings => {
#        'PHP/precision' => '14',
#        'PHP/zlib.output_compression' => 'Off'
#     }
#   }
#
#   augeas_base::settings_to_file { '/etc/php.ini':
#      settings => {
#        'PHP/precision' => '14',
#        'PHP/zlib.output_compression' => 'Off'
#     },
#     additional_context => 'PHP'
#   }
#
# @param settings Hash of settings to set
# @param config_file If specified, instead of the title (namevar) this config file is used
# @param additional_context If specified, the context will be appended by "/<additional_context>"
# @param lens If specified, the augeas_base::default_lens (if defined), or simply 'Puppet.lns' is used
# @param create_if_empty If set to true, the config will be created if it does not exist, otherwise not
# @param specify_lens If set to true, the lens/incl for augeas will be specified, if false the parameters are spared, which enables the autodetection of augeas

define augeas_base::settings_to_file (
  $settings,
  $config_file = undef,
  $additional_context = undef,
  $lens = undef,
  $create_if_empty = true,
  $specify_lens = true,
)  {

  validate_legacy('Hash', 'validate_hash', $settings)

  $real_config_file = $config_file ? { undef => $title, default => $config_file }
  validate_legacy('String', 'validate_absolute_path', $real_config_file)

  $changes = flatten([suffix(prefix(sort(join_keys_to_values($settings, '" "')), 'set "'), '"'), ])

  if $lens != undef {
    $real_lens = $lens
  }
  #elsif defined ('::augeas_base') and defined ('::augeas_base::default_lens') and $::augeas_base::default_lens != undef {
  elsif defined ('::augeas_base') and getvar ('augeas_base::default_lens') {
    $real_lens = $augeas_base::default_lens
  }
  else {
    $real_lens = 'Puppet.lns'
  }

  $context = $additional_context ? {
    undef   => "/files${real_config_file}",
    default => "/files${real_config_file}/${additional_context}"
  }

  if ($create_if_empty) {
    file { $real_config_file:
      ensure => file,
      before => Augeas[$context],
    }
  }

  if $specify_lens {
    augeas { $context:
      context => $context,
      changes => $changes,
      lens    => $real_lens,
      incl    => $real_config_file,
    }
  }
  else {
    augeas { $context:
      context => $context,
      changes => $changes,
    }
  }
}
