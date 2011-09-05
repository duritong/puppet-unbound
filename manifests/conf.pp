define unbound::conf(
  $ensure = present,
  $content = 'absent',
  $source = 'absent'
){
  file{"/etc/unbound/conf.d/${name}.conf":
    ensure => $ensure,
    notify => Service['unbound'],
    owner => root, group => 0, mode => 0644;
  }
  if $source != 'absent' {
    File["/etc/unbound/conf.d/${name}.conf"]{
      source => $source
    }
  } else {
    File["/etc/unbound/conf.d/${name}.conf"]{
      content => $content,
    }
  }

  line{"${name}_unbound_include":
    line => "Include: /etc/unbound/conf.d/${name}.conf",
    file => "/etc/unbound/conf.d/includes.conf",
    ensure => $ensure,
  }
}
