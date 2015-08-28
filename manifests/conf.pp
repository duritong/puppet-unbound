# deploy a simple config snippet
define unbound::conf(
  $ensure  = present,
  $content = undef,
  $source  = undef,
){
  file{"/etc/unbound/conf.d/${name}.conf":
    ensure  => $ensure,
    require => Package['unbound'],
    notify  => Service['unbound'],
    owner   => root,
    group   => 0,
    mode    => '0640';
  }
  if $ensure == 'present' {
    if $source {
      File["/etc/unbound/conf.d/${name}.conf"]{
        source => $source
      }
    } else {
      if !$content and $ensure == 'present' {
        fail('Must define content')
      }
      File["/etc/unbound/conf.d/${name}.conf"]{
        content => $content,
      }
    }
  }

  file_line{"${name}_unbound_include":
    ensure => $ensure,
    line   => "Include: /etc/unbound/conf.d/${name}.conf",
    path   => '/etc/unbound/conf.d/includes.conf',
    notify => Service['unbound'],
  }
}
