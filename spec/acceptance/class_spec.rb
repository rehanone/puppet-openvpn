require 'spec_helper_acceptance'

describe 'openvpn class:', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'openvpn is expected to run successfully' do
    pp = "class { 'openvpn': }"

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true) do |r|
      expect(r.stderr).not_to match(%r{error}i)
    end
    apply_manifest(pp, catch_failures: true) do |r|
      expect(r.stderr).not_to eq(%r{error}i)

      expect(r.exit_code).to be_zero
    end
  end

  context 'secrets_manage => true:' do
    it 'runs successfully' do
      shell 'rm -fv /etc/openvpn/easyrsa/*'

      pp = "class { 'openvpn': secrets_manage => true }"

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end

      shell('test -e /etc/openvpn/easyrsa')
    end
  end

  context 'package_ensure => present:' do
    it 'runs successfully to ensure package is installed' do
      pp = "class { 'openvpn': package_ensure => present }"

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end
    end
  end

  context 'service_ensure => running:' do
    it 'starts the service successfully' do
      pp = "class { 'openvpn': service_ensure => running }"

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end
    end
  end

  context 'service_ensure => stopped:' do
    it 'stops the service successfully' do
      pp = "class { 'openvpn': service_ensure => stopped }"

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end
    end
  end

  context 'firewall_manage => true:' do
    it 'runs successfully' do
      pp = "class { 'openvpn': firewall_manage => true }"

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end
    end
  end

  context 'package_ensure => absent:' do
    it 'runs successfully to ensure package is uninstalled' do
      pp = "class { 'openvpn': package_ensure => absent, service_manage => false }"

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end
    end
  end
end
