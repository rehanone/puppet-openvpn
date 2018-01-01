class openvpn::service () inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if !($openvpn::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $openvpn::service_manage and $::facts['service_provider'] != 'systemd' {
    service { $openvpn::service_name:
      ensure    => $openvpn::service_ensure,
      enable    => $openvpn::service_enable,
      name      => $openvpn::service_name,
      subscribe => Class["${module_name}::config"],
    }
  }
}
