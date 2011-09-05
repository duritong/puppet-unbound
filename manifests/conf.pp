class unbound::conf($content){
  file{"/etc/unbound/conf.d/${name}.conf":
    content => $content,
    notify => Service['unbound'],
    owner => root, group => 0, mode => 0644;
  }
}
