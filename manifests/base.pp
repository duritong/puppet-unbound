# setup all necessary stuff for unbound
class unbound::base {
  package { 'unbound':
    ensure => present,
  }

  $unbound_interface_str = $unbound::interface ? {
    'all'   => '',
    default => "${Array($unbound::interface,true).filter |$i| { $i !~ String[1] }.map |$i| { "interface: ${i}" }.join("\n")}\n",
  }

  file {
    '/etc/unbound/unbound.conf':
      source  => [
        "puppet:///modules/unbound/config/unbound.conf.${facts['os']['name']}.${facts['os']['release']['major']}",
        "puppet:///modules/unbound/config/unbound.conf.${facts['os']['name']}",
        'puppet:///modules/unbound/config/unbound.conf',
      ];
    '/etc/unbound/conf.d':
      ensure  => directory,
      purge   => true,
      force   => true,
      recurse => true;
    '/etc/unbound/conf.d/includes.conf':
      ensure  => file;
    '/etc/unbound/conf.d/server_acls.conf':
      content => template('unbound/server_acls.conf.erb');
    '/etc/unbound/conf.d/server_interface.conf':
      content => $unbound_interface_str;
    '/etc/unbound/conf.d/local_data.conf':
      source  => $unbound::local_data_source;
  }
  File['/etc/unbound/unbound.conf','/etc/unbound/conf.d',
    '/etc/unbound/conf.d/includes.conf',
    '/etc/unbound/conf.d/server_acls.conf',
    '/etc/unbound/conf.d/local_data.conf',
  '/etc/unbound/conf.d/server_interface.conf'] {
    require => Package['unbound'],
    notify  => Service['unbound'],
    owner   => root,
    group   => 0,
    mode    => '0644',
  }

  service { 'unbound':
    ensure => running,
    enable => true,
  }
}
