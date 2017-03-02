# Augeas base class which holds global settings for the defines
#
# @param default_lens If specified, this lens will be used on all defines
# @param default_owner If specified, this string will be used for owner/group of the settingfile file{} object
# @param manage_user_group If true, the class manages the User/Group object '$default_owner'
#
class augeas_base (
  $default_lens = undef,
  $default_owner = undef,
  $manage_user_group = true,
) {

  if $manage_user_group and $default_owner != undef {
    User {$default_owner:
      ensure => present,
    }
    Group {$default_owner:
      ensure => present,
    }
  }

}