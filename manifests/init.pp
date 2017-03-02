# Augeas base class which holds global settings for the defines
#
# @param default_lens If specified, this lens will be used on all defines
# @param default_owner If specified, this string will be used for owner/group of the settingfile file{} object
#
class augeas_base (
  $default_lens = undef,
  $default_owner = undef
) {

}