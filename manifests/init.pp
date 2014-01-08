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
#  * local_data_source: from where to fetch the local data file
class unbound(
  $interface          = '',
  $acls               = '',
  $manage_munin       = false,
  $manage_shorewall   = false,
  $nagios_test_domain = 'absent',
  $local_data_source  = [ "puppet:///modules/site_unbound/${::fqdn}/config/conf.d/local_data.conf",
                          "puppet:///modules/site_unbound/${::domain}/config/conf.d/local_data.conf",
                          'puppet:///modules/site_unbound/config/conf.d/local_data.conf',
                          'puppet:///modules/unbound/config/conf.d/local_data.conf' ],
){
  case $::operatingsystem {
    default: { include unbound::base }
  }

  # debian is currently not supported for munin plugins
  if $manage_munin and $::operatingsystem != 'Debian' {
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
