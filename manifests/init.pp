class unbound(
  $interface = '',
  $acls = '',
  $manage_munin = false,
  $manage_shorewall = false,
  $nagios_test_domain = 'absent'
){
  include unbound::base
    
  if $manage_munin {
    include unbound::munin
  }
  if $manage_shorewall {
    include shorewall::rules::dns
  }
  if $nagios_test_domains != 'absent' {
    nagios::service::dns{
      "unbound_${nagios_test_domain}":
        check_domain  => $nagios_test_domain,
        ip            => $unbound::interface ? {
          ''      => $::ipaddress,
          default => $unbound::interface
        }
    }
  }
}
