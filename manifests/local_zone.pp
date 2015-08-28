# define a local-zone in /etc/unbound/local.d/
define unbound::local_zone(
  $values
) {
  file{
    "/etc/unbound/local.d/${name}.conf":
      content => template('unbound/local-zone.erb'),
      require => Package['unbound'],
      notify  => Service['unbound'],
      owner   => root,
      group   => 0,
      mode    => '0644';
  }
}
