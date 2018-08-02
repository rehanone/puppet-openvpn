require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Openvpn::TapDevice' do
    describe 'accepts tap with single digit' do
      ['tap0', 'tap1', 'tap1000'].each do |value|
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
        'atap1000',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
