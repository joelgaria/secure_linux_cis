# @api private
#
class secure_linux_cis::distribution::suse12::cis_3_4_3 {
  include secure_linux_cis::rules::ensure_etc_hosts_deny_is_configured
}
