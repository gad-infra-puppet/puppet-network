require 'facter'
require 'open-uri'
require 'timeout'

#Public IP
# Expected output: The public ipaddress of this node.
# Facter.add("network_public_ip") do
#   setcode do
#     Timeout::timeout(2) do
#       open('http://ip-echo.appspot.com', 'User-Agent' => 'Ruby/Facter').read.match(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/).to_s
#     end
#   end
# end

#Gateway
# Expected output: The ip address of the nexthop/default router
Facter.add("network_nexthop_ip") do
  my_gw = nil
  confine :kernel => :linux
  setcode do
    gw_address = Facter::Util::Resolution.exec('/sbin/ip route show 0/0')
    if gw_address
      my_gw = gw_address.split(/\s+/)[2].match(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/).to_s
    end
    my_gw
  end
end

#Primary interface
#  Expected output: The specific interface name that the node uses to communicate with the nexthop
Facter.add("network_primary_interface") do
  confine :kernel => :linux
  setcode do
    gw_address = Facter::Util::Resolution.exec('/sbin/ip route show 0/0')
    if gw_address
      my_gw = gw_address.split(/\s+/)[2].match(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/).to_s
      fun = Facter::Util::Resolution.exec("/sbin/ip route get #{my_gw}").split("\n")[0]
      fun.split(/\s+/)[2].to_s
    end
  end
end

#Primary IP
#  Expected output: The ipaddress confugred on the interface that communicates with the nexthop
Facter.add("network_primary_ip") do
  confine :kernel => :linux
  setcode do
    gw_address = Facter::Util::Resolution.exec('/sbin/ip route show 0/0')
    if gw_address
      my_gw = gw_address.split(/\s+/)[2].match(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/).to_s
      fun = Facter::Util::Resolution.exec("/sbin/ip route get #{my_gw}").split("\n")[0]
      fun.split(/\s+/)[4].to_s
    end
  end
end