# mapper for multiple service defines
define unbound::local_zones (
  $values,
) {
  unbound::local_zone {
    $name:
      values => $values[$name],
  }
}
