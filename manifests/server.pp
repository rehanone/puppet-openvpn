define openvpn::server (
  String     $key_name     = $title,
  Integer[0] $key_size     = $openvpn::key_size,
  Integer[0] $ca_expire    = $openvpn::ca_expire,
  Integer[0] $key_expire   = $openvpn::key_expire,
  String     $country      = $openvpn::country,
  String     $state        = $openvpn::state,
  String     $city         = $openvpn::city,
  String     $organization = $openvpn::organization,
  String     $email        = $openvpn::email,
  String     $org_unit     = $openvpn::org_unit,

  Integer[0, 65535]
             $port         = $openvpn::params::port,
  Enum[tcp, udp]
             $proto        = $openvpn::params::proto,
  Enum[tun, tap]
             $dev          = $openvpn::params::dev,
  String     $user         = $openvpn::params::user,
  String     $group        = $openvpn::params::group,
  Optional[String]
             $cipher       = $openvpn::params::cipher,
  Optional[String]
             $server       = $openvpn::params::server,
  Array[String]
             $routes       = $openvpn::params::routes,
  Optional[Integer[0]]
             $max_clients  = $openvpn::params::max_clients,
) {

  Class["${module_name}::easyrsa"] -> Openvpn::Server[$title]

  $log_dir  = "${openvpn::log_dir}/${title}"
  $keys_dir = $openvpn::pki

  easyrsa::server { $title:
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

  # Create log directory for this server
  file { $log_dir:
    ensure  => directory,
    group   => 'root',
    owner   => 'root',
    require => Class["${module_name}::install"],
  }

  # Create server config
  file { "${openvpn::conf_dir}/${title}.conf":
    content => epp("${module_name}/server.conf.epp",
      {
        'key_name'    => $key_name,
        'keys_dir'    => $keys_dir,
        'log_dir'     => $log_dir,

        'port'        => $port,
        'proto'       => $proto,
        'dev'         => $dev,
        'server'      => $server,
        'routes'      => $routes,
        'user'        => $user,
        'group'       => $group,
        'cipher'      => $cipher,
        'max_clients' => $max_clients,
      }
    ),
    notify  => Class["${module_name}::service"],
  }

  if $::service_provider == 'systemd' {
    service { "${openvpn::service_name}@${title}":
      ensure    => $openvpn::service_ensure,
      enable    => $openvpn::service_enable,
      name      => "${openvpn::service_name}@${title}",
      subscribe => File["${openvpn::conf_dir}/${title}.conf"],
    }
  }

  if $openvpn::firewall_manage and defined('::firewall') {
    firewall { "${port} Allow inbound ${proto} connection on port: ${port}":
      dport  => $port,
      proto  => $proto,
      action => accept,
    }
  }
}
