# mapper for multiple forward zone defines
define unbound::forward_zones(
  $values,
) {
  unbound::forward_zone{
    $name:
      addrs => $values[$name],
  }
}
