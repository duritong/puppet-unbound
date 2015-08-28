#manages a forward zone
define unbound::forward_zone(
  $hosts  = [],
  $addrs  = [],
  $first  = undef,
) {

  if (empty($addrs) and empty($hosts)) or (!addrs or !$hosts) {
    fail("${name} requires addrs or hosts")
  }
  if $first {
    validate_re($first, [ '^yes$', '^no$' ])
  }

  if $name == '.' {
    $file_name = 'default'
  } else {
    $file_name = $name
  }

  unbound::conf{$file_name:
    content => template('unbound/forward-zone.erb'),
  }
}
