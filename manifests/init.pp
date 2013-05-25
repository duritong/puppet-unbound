# configure unbound lookup service
#
# Parameters:
#
#  * interface: Should we listen on a dedicated ip_address? Default: '' == all
#  * acls: Who should be able to query unbound? Default: '' == all
#  * manage_munin: Munin plugins? Default: false
#  * manage_shorewall: Open ports in shorewall? Default: false
#  * nagios_test_domain: Export nagios tests to check if the domain
#                        passed in this parameter resolves?
#                        Default: 'absent' == No nagios checks
class unbound(
  $interface = '',
  $acls = '',
  $manage_munin = false,
  $manage_shorewall = false,
  $nagios_test_domain = 'absent'
){
  case $::operatingsystem {
    default: { include unbound::base }
  }

  if $manage_munin {
    include unbound::munin
  }
  if $manage_shorewall {
    include shorewall::rules::dns
  }
  if $nagios_test_domain != 'absent' {
    $ip = $unbound::interface ? {
            ''      => $::ipaddress,
            default => $unbound::interface
    }
    nagios::service::dns{
      "unbound_${nagios_test_domain}":
        check_domain  => $nagios_test_domain,
        ip            => $ip,
    }
  }
}
