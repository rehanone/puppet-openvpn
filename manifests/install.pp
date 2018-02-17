class openvpn::install inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  package { $openvpn::package_name:
    ensure => $openvpn::package_ensure,
    alias  => 'openvpn',
  }
  -> file { $openvpn::conf_dir:
    ensure => directory,
  }
}
