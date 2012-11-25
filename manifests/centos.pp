# on EL6 we need to activate the manage port in selinux
# https://bugzilla.redhat.com/show_bug.cgi?id=732276
class unbound::centos inherits unbound::base {
  if ($::lsbmajdistrelease == 6) and ($::selinux == 'true') {
    selinux::seport{
      '8953':
        setype => 'dns_port',
        before => Service['unbound'];
    }
  }
}
