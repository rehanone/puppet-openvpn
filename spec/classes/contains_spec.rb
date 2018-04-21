# To check the correct dependencies are set up for openvpn.

require 'spec_helper'
describe 'openvpn' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it {
        is_expected.to compile.with_all_deps
      }

      describe 'Testing the dependencies between the classes' do
        it { is_expected.to contain_class('openvpn::repo') }
        it { is_expected.to contain_class('openvpn::install') }
        it { is_expected.to contain_class('openvpn::easyrsa') }
        it { is_expected.to contain_class('openvpn::sysctl_forward') }
        it { is_expected.to contain_class('openvpn::config') }
        it { is_expected.to contain_class('openvpn::service') }
        it { is_expected.to contain_class('openvpn::firewall') }

        it { is_expected.to contain_class('openvpn::repo').that_comes_before('Class[openvpn::install]') }
        it { is_expected.to contain_class('openvpn::install').that_comes_before('Class[openvpn::easyrsa]') }
        it { is_expected.to contain_class('openvpn::easyrsa').that_comes_before('Class[openvpn::sysctl_forward]') }
        it { is_expected.to contain_class('openvpn::sysctl_forward').that_comes_before('Class[openvpn::config]') }
        it { is_expected.to contain_class('openvpn::config').that_comes_before('Class[openvpn::service]') }
        it { is_expected.to contain_class('openvpn::service').that_comes_before('Class[openvpn::firewall]') }
      end
    end
  end
end
