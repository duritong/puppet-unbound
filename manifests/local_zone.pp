# define a local-zone in /etc/unbound/local.d/
define unbound::local_zone (
  $values,
) {
  unbound::conf {
    $name:
      content => template('unbound/local-zone.erb'),
  }
}
