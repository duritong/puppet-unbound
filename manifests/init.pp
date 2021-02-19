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
class unbound (
  String[2] $interface          = 'all',
  Hash      $acls               = {},
  Boolean   $manage_munin       = false,
  Boolean   $manage_firewall    = false,
  String[1] $nagios_test_domain = 'absent',
  Hash      $local_zones        = {},
  Hash      $forward_zones      = {},
  Variant[Array[String[1]],String[1]]
  $local_data_source  = ["puppet:///modules/site_unbound/${facts['networking']['fqdn']}/config/conf.d/local_data.conf",
    "puppet:///modules/site_unbound/${facts['networking']['domain']}/config/conf.d/local_data.conf",
    'puppet:///modules/site_unbound/config/conf.d/local_data.conf',
  'puppet:///modules/unbound/config/conf.d/local_data.conf'],
) {
  include unbound::base

  # debian is currently not supported for munin plugins
  if $manage_munin and $facts['os']['name'] != 'Debian' {
    include unbound::munin
  }
  if $manage_firewall {
    include firewall::rules::dns
  }
  if $nagios_test_domain != 'absent' {
    $ip = $interface ? {
      'all'   => pick($facts['default_ipaddress'],$facts['networking']['ip']),
      default => $interface
    }
    nagios::service::dns {
      "unbound_${nagios_test_domain}":
        check_domain => $nagios_test_domain,
        ip           => $ip,
    }
  }

  if !empty($local_zones) {
    $lzs = keys($local_zones)
    unbound::local_zones {
      $lzs:
        values => $local_zones;
    }
  }
  if !empty($forward_zones) {
    $fzs = keys($forward_zones)
    unbound::forward_zones {
      $fzs:
        values => $forward_zones;
    }
  }
}
