# Configure package sources for Openvpn
class openvpn::repo inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $openvpn::repo_manage {
    case $::operatingsystem {
      'RedHat', 'Fedora', 'CentOS': {
        contain epel
      }
      'Gentoo': {
      }
      'Ubuntu', 'Debian': {
        case $::lsbdistcodename {
          'precise', 'trusty', 'xenial': {
            contain apt

            $openvpn_key_url = 'swupdate.openvpn.net'
            $openvpn_src_url = 'build.openvpn.net'

            apt::key { $openvpn_key_url:
              id     => '30EBF4E73CCE63EEE124DD278E6DA8B4E158C569',
              source => "https://${openvpn_key_url}/repos/repo-public.gpg",
            }

            apt::source { $openvpn_src_url:
              location => "http://${openvpn_src_url}/debian/openvpn/release/2.4",
              repos    => 'main',
              include  => { 'src' => false },
            }
          }
          default: {}
        }
      }
      'Archlinux': {
      }
      default: {
      }
    }
  }
}
