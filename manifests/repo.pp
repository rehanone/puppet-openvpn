# Configure package sources for Openvpn
class openvpn::repo inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $openvpn::repo_manage {
    case $::facts[os][family] {
      'RedHat': {
        require epel
      }
      'Debian': {
        contain apt

        $openvpn_key_hash = lookup('openvpn::repo_key_hash')
        $openvpn_key_url = lookup('openvpn::repo_key_url')
        $openvpn_src_url = lookup('openvpn::repo_src_url')

        apt::key { 'openvpn-import-repository-key':
          id     => $openvpn_key_hash,
          source => $openvpn_key_url,
        }

        apt::source { 'build.openvpn.net':
          location => $openvpn_src_url,
          repos    => 'main',
          include  => { 'src' => false },
        }
      }
      'Archlinux': {
      }
      default: {
      }
    }
  }
}
