# configure munin plugins for unbound
class unbound::munin {
  package{'unbound-munin':
    ensure => present,
  }

  munin::plugin{ [  'unbound_munin_by_class', 'unbound_munin_by_flags',
                    'unbound_munin_by_opcode', 'unbound_munin_by_rcode',
                    'unbound_munin_by_type', 'unbound_munin_histogram',
                    'unbound_munin_hits', 'unbound_munin_memory',
                    'unbound_munin_queue' ]:
    config  => "user root
env.statefile /var/lib/munin/plugin-state/unbound-state
env.unbound_conf /etc/unbound/unbound.conf
env.unbound_control /usr/sbin/unbound-control
env.spoof_warn 1000
env.spoof_crit 100000
",
    require => Package['unbound-munin'],
  }
}
