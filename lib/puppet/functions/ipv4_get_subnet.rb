
Puppet::Functions.create_function(:ipv4_get_subnet) do
  dispatch :ipv4_get_subnet do
    param 'Stdlib::Compat::Ipv4', :value
  end

  def ipv4_get_subnet(value)
    subnet = value.split('/')[1]

    return subnet if subnet.include? '.'

    require 'ipaddr'

    base = IPAddr.new('255.255.255.255')
    base.mask(subnet.to_i).to_string
  end
end
