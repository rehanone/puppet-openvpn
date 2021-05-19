class openvpn::easyrsa () inherits openvpn {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $openvpn::secrets_manage {

    class { 'easyrsa':
      git_manage => $openvpn::git_manage,
      pkiroot    => $openvpn::pkiroot,
      pkis       => {
        $openvpn::pkiname => {},
      },
      cas        => {
        $openvpn::pkiname => {
          ca_name      => $openvpn::ca_name,
          key          => {
            algo       => $openvpn::key_algo,
            size       => $openvpn::key_size,
            valid_days => $openvpn::ca_expire,
          },
          country      => $openvpn::country,
          state        => $openvpn::state,
          city         => $openvpn::city,
          email        => $openvpn::email,
          organization => $openvpn::organization,
          org_unit     => $openvpn::org_unit,
        },
      },
      dhparams   => {
        $openvpn::pkiname => {
          key_size => $openvpn::dh_key_size,
        },
      },
      require    => Class["${module_name}::install"],
    }
    -> exec { "genkey-ta-${openvpn::pki}-ta.key":
      command  => 'openvpn --genkey --secret ta.key',
      cwd      => $openvpn::pki,
      creates  => "${openvpn::pki}/ta.key",
      provider => shell,
    }
  }
}
