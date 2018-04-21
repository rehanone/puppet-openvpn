
Puppet::Functions.create_function(:ipv4_cidr_to_subnet) do
  dispatch :ipv4_cidr_to_subnet do
    param 'Integer[0, 30]', :value
  end

  def ipv4_cidr_to_subnet(value)
    require 'ipaddr'

    base = IPAddr.new('255.255.255.255')
    base.mask(value).to_string
  end
end
