class openvpn::config () inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  file { $openvpn::log_dir:
    ensure => directory,
  }

  if $openvpn::secrets_manage {
    file { $openvpn::bundles_dir:
      ensure => directory,
    }
  }

  create_resources(openvpn::server, $openvpn::servers)
  create_resources(openvpn::client, $openvpn::clients)
}
