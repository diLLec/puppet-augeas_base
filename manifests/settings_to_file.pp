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
# @param manage_file If set to true, the settings_to_file will manage the config_file within a file {} ressource
# @param specify_lens If set to true, the lens/incl for augeas will be specified, if false the parameters are spared, which enables the autodetection of augeas

define augeas_base::settings_to_file (
  Hash $settings,
  Optional[String] $config_file = undef,
  Optional[String] $additional_context = undef,
  Optional[String] $lens = undef,
  Optional[Boolean] $manage_file = true,
  Optional[Boolean] $specify_lens = true,
)  {

  validate_legacy('Hash', 'validate_hash', $settings)

  $real_config_file = $config_file ? { undef => $title, default => $config_file }
  validate_legacy('String', 'validate_absolute_path', $real_config_file)

  $changes = flatten([suffix(prefix(sort(join_keys_to_values($settings, '" "')), 'set "'), '"'), ])
  $real_lens = pick(getvar('augeas_base::default_lens'), $lens, 'Puppet.lns')

  $context = $additional_context ? {
    undef   => "/files${real_config_file}",
    default => "/files${real_config_file}/${additional_context}"
  }

  if $manage_file and !defined(File[$real_config_file]) {
    if getvar ('augeas_base::default_owner') != undef {
      file { $real_config_file:
        ensure  => file,
        before  => Augeas[$title],
        owner   => $augeas_base::default_owner,
        group   => $augeas_base::default_owner,
        require => [
          User[$augeas_base::default_owner],
          Group[$augeas_base::default_owner],
        ],
      }
    }
    else {
      file { $real_config_file:
        ensure => file,
        before => Augeas[$title],
      }
    }
  }

  if $specify_lens {
    augeas { $title:
      context => $context,
      changes => $changes,
      lens    => $real_lens,
      incl    => $real_config_file,
    }
  }
  else {
    augeas { $title:
      context => $context,
      changes => $changes,
    }
  }
}
