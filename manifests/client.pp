# Define OpenVPN client client specific config.
define openvpn::client (
  String     $server,
  String     $key_name      = $title,
  Integer[0] $key_size      = $openvpn::key_size,
  Integer[0] $ca_expire     = $openvpn::ca_expire,
  Integer[0] $key_expire    = $openvpn::key_expire,
  String     $country       = $openvpn::country,
  String     $state         = $openvpn::state,
  String     $city          = $openvpn::city,
  String     $organization  = $openvpn::organization,
  String     $email         = $openvpn::email,
  String     $org_unit      = $openvpn::org_unit,

  Integer[0, 65535]
  $port                     = lookup('openvpn::port', Integer),
  Enum[tcp, udp]
  $proto                    = lookup('openvpn::proto', Enum[tcp, udp]),
  Openvpn::VpnInterface
  $vpn_device               = lookup('openvpn::vpn_device', Openvpn::VpnInterface),
  String     $user          = lookup('openvpn::user', String),
  String     $group         = lookup('openvpn::group', String),
  Optional[String]
  $cipher                   = lookup('openvpn::cipher', Optional[String], 'first', undef),

  Boolean    $windows_based = false,
) {

  Openvpn::Server[$server] -> Openvpn::Client[$title]

  if $windows_based {
    $client_keys_dir = 'D:/openvpn/keys'
    $conf_extension = 'ovpn'
    $the_user = undef
    $the_group = undef
  } else {
    $client_keys_dir = $openvpn::keys_dir
    $conf_extension = 'conf'
    $the_user = $user
    $the_group = $group
  }

  easyrsa::client { $title:
    pki_name     => $openvpn::pkiname,
    key          => {
      algo       => $openvpn::key_algo,
      size       => $openvpn::key_size,
      valid_days => $openvpn::key_expire,
    },
    country      => $openvpn::country,
    state        => $openvpn::state,
    city         => $openvpn::city,
    email        => $openvpn::email,
    organization => $openvpn::organization,
    org_unit     => $openvpn::org_unit,
  }

  file {
    [ "${openvpn::bundles_dir}/${key_name}",
      "${openvpn::bundles_dir}/${key_name}/keys"
    ]:
      ensure  => directory,
      require => File[$openvpn::bundles_dir];

    "${openvpn::bundles_dir}/${key_name}/keys/${key_name}.crt":
      ensure  => link,
      target  => "${openvpn::pki}/issued/${key_name}.crt",
      require => Easyrsa::Client[$title];

    "${openvpn::bundles_dir}/${key_name}/keys/${key_name}.key":
      ensure  => link,
      target  => "${openvpn::pki}/private/${key_name}.key",
      require => Easyrsa::Client[$title];

    "${openvpn::bundles_dir}/${key_name}/keys/ca.crt":
      ensure  => link,
      target  => "${openvpn::pki}/ca.crt",
      require => Easyrsa::Client[$title];

    "${openvpn::bundles_dir}/${key_name}/keys/ta.key":
      ensure  => link,
      target  => "${openvpn::pki}/ta.key",
      require => Easyrsa::Client[$title];
  }

  file { "${openvpn::bundles_dir}/${key_name}/${key_name}.conf":
    path    => "${openvpn::bundles_dir}/${key_name}/${key_name}.${conf_extension}",
    owner   => root,
    group   => root,
    mode    => '0444',
    content => epp("${module_name}/client.epp",
      {
        'key_name' => $key_name,
        'keys_dir' => $client_keys_dir,

        'port'     => $port,
        'proto'    => $proto,
        'dev'      => $vpn_device[0, 3],
        'server'   => $server,
        'user'     => $the_user,
        'group'    => $the_group,
        'cipher'   => $cipher,
      }
    ),
    notify  => Exec["tar-${key_name}"];
  }

  exec {
    "rm-${key_name}-old":
      cwd         => "${openvpn::bundles_dir}/",
      command     => "rm -f ${key_name}.tar.gz",
      path        => '/bin',
      refreshonly => true,
      loglevel    => debug,
      logoutput   => true,
      returns     => ['0', '1'],
      subscribe   => [
        File["${openvpn::bundles_dir}/${key_name}/${key_name}.conf"],
        File["${openvpn::bundles_dir}/${key_name}/keys/ca.crt"],
        File["${openvpn::bundles_dir}/${key_name}/keys/ta.key"],
        File["${openvpn::bundles_dir}/${key_name}/keys/${key_name}.key"],
        File["${openvpn::bundles_dir}/${key_name}/keys/${key_name}.crt"]
      ];
    "tar-${key_name}":
      cwd         => "${openvpn::bundles_dir}/",
      command     => "rm -f ${key_name}.tar.gz; tar -chzvf ${key_name}.tar.gz ${key_name}",
      path        => '/bin',
      refreshonly => true,
      loglevel    => debug,
      logoutput   => true,
      returns     => ['0', '1'],
      subscribe   => Exec["rm-${key_name}-old"];
  }
}
