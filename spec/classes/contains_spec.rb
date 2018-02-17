# To check the correct dependencies are set up for openvpn.

require 'spec_helper'
describe 'openvpn' do
  let(:facts) {{ :is_virtual => 'false' }}

  on_supported_os.select { |_, f| f[:os]['family'] != 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      it { is_expected.to compile.with_all_deps }
      describe "Testing the dependancies between the classes" do
        it { should contain_class('openvpn::repo') }
        it { should contain_class('openvpn::install') }
        it { should contain_class('openvpn::easyrsa') }
        it { should contain_class('openvpn::config') }
        it { should contain_class('openvpn::service') }

        it { is_expected.to contain_class('openvpn::repo').that_comes_before('Class[openvpn::install]') }
        it { is_expected.to contain_class('openvpn::install').that_comes_before('Class[openvpn::easyrsa]') }
        it { is_expected.to contain_class('openvpn::easyrsa').that_comes_before('Class[openvpn::config]') }
        it { is_expected.to contain_class('openvpn::config').that_comes_before('Class[openvpn::service]') }
      end
    end
  end
end