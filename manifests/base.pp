class unbound::base {
  package{'unbound':
    ensure => present,
  }

  file{
    '/etc/unbound/unbound.conf':
      source => "puppet:///modules/unbound/config/unbound.conf";
    '/etc/unbound/conf.d':
      ensure => directory,
      purge => true,
      force => true,
      recurse => true;
    '/etc/unbound/conf.d/includes.conf':
      ensure => present;
    '/etc/unbound/conf.d/server_acls.conf':
      content => template('unbound/server_acls.conf.erb');
    '/etc/unbound/conf.d/server_interface.conf':
      content => $unbound::interface ? {
        '' => '',
        default => "interface: $unbound::interface\n"
      };
  }
  File['/etc/unbound/unbound.conf','/etc/unbound/conf.d',
       '/etc/unbound/conf.d/includes.conf',
       '/etc/unbound/conf.d/server_acls.conf',
       '/etc/unbound/conf.d/server_interface.conf']{
    require => Package['unbound'],
    notify => Service['unbound'],
    owner => root, group => 0, mode => 0644
  }

  unbound::conf{'local_data':
    source => [ "puppet:///modules/site-unbound/${fqdn}/config/conf.d/local_data.conf",
                "puppet:///modules/site-unbound/${domain}/config/conf.d/local_data.conf",
                'puppet:///modules/site-unbound/config/conf.d/local_data.conf',
                'puppet:///modules/unbound/config/conf.d/local_data.conf' ]
  }

  service{'unbound':
    enable => true,
    ensure => running,
  } 
}
