# @api private
#
class secure_linux_cis::distribution::rhel8::cis_3_3_3 {
  include secure_linux_cis::rules::ensure_rds_is_disabled
}
