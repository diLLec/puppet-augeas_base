# A define, which can be used to add settings to configs, which describe a locally existent directory which you want
# to ensured that they exist.
#
# @param dirsettings Hash of settings, which reference directories in seetings
# @param filesettings Hash of settings, which reference files in seetings
# @param config_file If specified, instead of the title (namevar) this config file is used
# @param additional_context If specified, the context will be appended by "/<additional_context>"
# @param lens If specified, the augeas_base::default_lens (if defined), or simply 'Puppet.lns' is used
# @param manage_file If set to true, the settings_to_file will manage the config_file within a file {} ressource
# @param specify_lens If set to true, the lens/incl for augeas will be specified, if false the parameters are spared, which enables the autodetection of augeas

define augeas_base::dirsettings_to_file (
  Hash $dirsettings,
  Hash $filesettings,
  Optional[String] $owner = undef,
  Optional[String] $config_file = undef,
  Optional[String] $additional_context = undef,
  Optional[String] $lens = undef,
  Optional[Boolean] $manage_file = true,
  Optional[Boolean] $specify_lens = true,
) {
  $real_owner = pick(getvar('augeas_base::default_owner'), $owner, '-NO_OWNER')

  $dirsettings.each |$key, $value| {
    if ($real_owner == '-NO_OWNER') {
      file {$value:
        ensure => directory,
      }
    }
    else {
      file {$value:
        ensure => directory,
        owner  => $real_owner,
        group  => $real_owner,
      }
    }
  }

  $filesettings.each |$key, $value| {
    if ($real_owner == '-NO_OWNER') {
      file {$value:
        ensure => file,
      }
    }
    else {
      file {$value:
        ensure  => file,
        owner   => $real_owner,
        group   => $real_owner,
        require => [
          User[$real_owner],
          Group[$real_owner],
        ],
      }
    }
  }

  augeas_base::settings_to_file { $title:
    settings           => deep_merge($dirsettings, $filesettings),
    config_file        => $config_file,
    additional_context => $additional_context,
    lens               => $lens,
    manage_file        => $manage_file,
    specify_lens       => $specify_lens,
  }
}