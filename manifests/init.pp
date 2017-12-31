
# Setup OpenVPN package and service
class openvpn (
  Boolean    $repo_manage      = $openvpn::params::repo_manage,
  String     $package_ensure   = $openvpn::params::package_ensure,
  String     $package_easyrsa  = $openvpn::params::package_easyrsa,
  String     $package_name     = $openvpn::params::package_name,
  Boolean    $service_enable   = $openvpn::params::service_enable,
  String     $service_ensure   = $openvpn::params::service_ensure,
  Boolean    $service_manage   = $openvpn::params::service_manage,
  String     $service_name     = $openvpn::params::service_name,
  Boolean    $firewall_manage  = $openvpn::params::firewall_manage,

  Stdlib::Absolutepath
             $conf_dir         = $openvpn::params::conf_dir,
  Stdlib::Absolutepath
             $keys_dir         = $openvpn::params::keys_dir,
  Stdlib::Absolutepath
             $log_dir          = $openvpn::params::log_dir,
  Stdlib::Absolutepath
             $bundles_dir      = $openvpn::params::bundles_dir,
  Stdlib::Absolutepath
             $pkiroot          = $openvpn::params::pkiroot,
  String     $pkiname          = $openvpn::params::pkiname,

  Boolean    $secrets_manage   = $openvpn::params::secrets_manage,
  String     $ca_name          = $openvpn::params::ca_name,
  Integer[0] $ca_expire        = $openvpn::params::ca_expire,
  Enum[rsa, ec]
             $key_algo         = $openvpn::params::key_algo,
  Integer[0] $key_size         = $openvpn::params::key_size,
  Integer[0] $dh_key_size      = $openvpn::params::dh_key_size,
  Integer[0] $key_expire       = $openvpn::params::key_expire,
  String     $country          = $openvpn::params::country,
  String     $state            = $openvpn::params::state,
  String     $city             = $openvpn::params::city,
  String     $organization     = $openvpn::params::organization,
  String     $email            = $openvpn::params::email,
  String     $org_unit         = $openvpn::params::org_unit,

  Hash       $servers          = lookup('openvpn::servers', Hash, 'hash', {}),
  Hash       $clients          = lookup('openvpn::clients', Hash, 'hash', {}),
  ) inherits openvpn::params {

  $pki = "${pkiroot}/${pkiname}"

  anchor { "${module_name}::begin": }
  -> class {"${module_name}::repo":}
  -> class {"${module_name}::install":}
  -> class {"${module_name}::easyrsa":}
  -> class {"${module_name}::config":}
  ~> class {"${module_name}::service":}
  -> anchor { "${module_name}::end": }
}
