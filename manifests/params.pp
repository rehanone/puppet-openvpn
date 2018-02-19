# Class: openvpn::params
#
class openvpn::params {
  $repo_manage       = true
  $package_ensure    = 'installed'
  $package_name      = 'openvpn'
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true
  $service_name      = 'openvpn'
  $firewall_manage   = true
  $sysctl_ip_forward = true

  $conf_dir          = '/etc/openvpn'
  $keys_dir          = "${conf_dir}/keys"
  $log_dir           = '/var/log/openvpn'
  $bundles_dir       = "${conf_dir}/bundles"
  $pkiroot           = "${conf_dir}/easyrsa"
  $pkiname           = 'ovpnpki'

  $secrets_manage    = false
  $ca_name           = 'EasyRSA'
  $key_algo          = 'rsa'
  $key_size          = 2048
  $dh_key_size       = 2048
  $ca_expire         = 3650
  $key_expire        = 3650
  $country           = 'UK'
  $state             = 'England'
  $city              = 'Dewsbury'
  $organization      = 'Your Company Limited'
  $email             = 'you@yourcompany.com'
  $org_unit          = 'your_dept'

  $port              = 1194
  $proto             = 'udp'
  $vpn_device        = 'tun0'
  $mapped_device     = 'eth0'
  $user              = 'nobody'
  $group             = 'nogroup'
  $cipher            = undef
  $routes            = []
  $max_clients       = undef
}
