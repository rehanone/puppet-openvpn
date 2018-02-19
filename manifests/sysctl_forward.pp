class openvpn::sysctl_forward () inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $openvpn::sysctl_ip_forward {
    sysctl { 'net.ipv4.ip_forward':
      ensure => present,
      value  => '1',
      target => '/etc/sysctl.d/60-forwarding.conf',
      apply  => $openvpn::sysctl_ip_forward,
    }
  }
}
