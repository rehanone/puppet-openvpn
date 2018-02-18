require 'spec_helper_acceptance'

describe 'openvpn class:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'should run successfully' do
    pp = "class { 'openvpn': }"

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stderr).not_to match(/error/i)
    end
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stderr).not_to eq(/error/i)

      expect(r.exit_code).to be_zero
    end
  end

  before do
    shell "rm -fv /etc/openvpn/easyrsa/*"
  end

  context 'repo_manage => true, secrets_manage => true:' do
    it 'runs successfully' do
      pp = "class { 'openvpn': repo_manage => true, secrets_manage => true }"

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).not_to match(/error/i)
      end

      shell('test -e /etc/openvpn/easyrsa')
    end
  end
end
