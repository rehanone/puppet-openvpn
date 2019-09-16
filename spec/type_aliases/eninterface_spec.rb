require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Openvpn::EnInterface' do
    describe 'accepts en interfaces with any other following characters' do
      ['enp2s0', 'enq2s1', 'enr2s3'].each do |value|
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
        'aeth1000',
        'enp 2s0',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
