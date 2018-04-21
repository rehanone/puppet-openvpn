
Puppet::Functions.create_function(:ipv4_get_address) do
  dispatch :ipv4_get_address do
    param 'Stdlib::Compat::Ipv4', :value
  end

  def ipv4_get_address(value)
    value.split('/')[0]
  end
end
