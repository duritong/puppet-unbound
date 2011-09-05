class unbound(
  $interface = hiera('unbound_interface',''),
  $acls = hiera('unbound_acls','')
){
  include unbound::base
    
  if hiera('use_munin',false) {
    include unbound::munin
  }
  if hiera('use_shorewall',false) {
    include shorewall::rules::dns
  }
}
