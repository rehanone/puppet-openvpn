require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Openvpn::VpnInterface' do
    describe 'accepts tun with single digit' do
      ['tun0', 'tun1', 'tun1000', 'tap0', 'tap1', 'tap1000'].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
        [],
        {},
        'abc1',
        true,
        'atun1000',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
