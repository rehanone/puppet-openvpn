require 'beaker-rspec'
require 'beaker/puppet_install_helper'

UNSUPPORTED_PLATFORMS = ['windows']

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'

  run_puppet_install_helper

  hosts.each do |host|
    environmentpath = host.puppet['environmentpath']
    environmentpath = environmentpath.split(':').first if environmentpath

    on host, puppet('module install puppetlabs-stdlib --version 4.24.0')
    on host, puppet('module install puppetlabs-apt --version 4.5.1')
    on host, puppet('module install stahnma-epel --version 1.3.0')
    on host, puppet('module install herculesteam-augeasproviders_sysctl --version 2.2.0')
    on host, puppet('module install rehan-easyrsa --version 0.3.1')
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      copy_module_to(host, :source => proj_root, :module_name => 'openvpn')
    end
  end
end
