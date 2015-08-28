#manages a forward zone
define unbound::forward_zone(
  $ensure = 'present',
  $hosts  = [],
  $addrs  = [],
  $first  = undef,
) {

  if $ensure == 'present' and ((empty($addrs) and empty($hosts)) or (!addrs or !$hosts)) {
    fail("${name} requires addrs or hosts if it should be present")
  }
  if $first {
    validate_re($first, [ '^yes$', '^no$' ])
  }

  if $name == '.' {
    $file_name = '/etc/unbound/conf.d/default.conf'
  } else {
    $file_name = "/etc/unbound/conf.d/${name}.conf"
  }

  file{$file_name:
    require => Package['unbound'],
    notify  => Service['unbound'],
  }

  if $ensure == 'present' {
    File[$file_name] {
      content => template('unbound/forward-zone.erb'),
      owner   => root,
      group   => 0,
      mode    => '0640',
    }
  } else {
    File[$file_name] {
      ensure => absent,
    }
  }

}
