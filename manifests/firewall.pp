class openvpn::firewall () inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $openvpn::firewall_manage and defined('::firewall') {

    firewall { '1020 FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT':
      chain  => 'FORWARD',
      proto  => all,
      state  => ['RELATED', 'ESTABLISHED'],
      action => accept,
    }
  }
}
