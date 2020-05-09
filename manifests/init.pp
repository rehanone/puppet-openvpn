# Setup OpenVPN package and service
class openvpn (
  Boolean       $git_manage,
  Boolean       $repo_manage,
  String        $package_ensure,
  String        $package_name,
  Boolean       $service_enable,
  String        $service_ensure,
  Boolean       $service_manage,
  String        $service_name,
  Boolean       $firewall_manage,
  Boolean       $sysctl_ip_forward,

  Stdlib::Absolutepath  $conf_dir,
  Stdlib::Absolutepath  $keys_dir,
  Stdlib::Absolutepath  $log_dir,
  Stdlib::Absolutepath  $bundles_dir,
  Stdlib::Absolutepath  $pkiroot,
  String                $pkiname,

  Boolean       $secrets_manage,
  String        $ca_name,
  Integer[0]    $ca_expire,
  Enum[rsa, ec] $key_algo,
  Integer[0]    $key_size,
  Integer[0]    $dh_key_size,
  Integer[0]    $key_expire,
  String        $country,
  String        $state,
  String        $city,
  String        $organization,
  String        $email,
  String        $org_unit,

  Hash          $servers = lookup('openvpn::servers', Hash, 'hash', {}),
  Hash          $clients = lookup('openvpn::clients', Hash, 'hash', {}),
) {

  $pki = "${pkiroot}/${pkiname}"

  anchor { "${module_name}::begin": }
  -> class { "${module_name}::repo": }
  -> class { "${module_name}::install": }
  -> class { "${module_name}::easyrsa": }
  -> class { "${module_name}::sysctl_forward": }
  -> class { "${module_name}::config": }
  ~> class { "${module_name}::service": }
  -> class { "${module_name}::firewall": }
  -> anchor { "${module_name}::end": }
}
