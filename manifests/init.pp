class unbound(
  $interface = '',
  $acls = '',
  $manage_munin = false,
  $manage_shorewall = false
){
  include unbound::base
    
  if $manage_munin {
    include unbound::munin
  }
  if $manage_shorewall {
    include shorewall::rules::dns
  }
}
