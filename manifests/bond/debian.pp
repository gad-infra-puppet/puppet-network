# = Define: network::bond::debian
#
# Instantiate bonded interfaces on Debian based systems.
#
# == See also
#
# * Debian Network Bonding http://wiki.debian.org/Bonding
define network::bond::debian(
  $slaves,
  $ensure    = present,
  $ipaddress = undef,
  $netmask   = undef,
  $method    = undef,
  $family    = undef,
  $onboot    = undef,
  $options   = {},

  $mode             = undef,
  $miimon           = undef,
  $downdelay        = undef,
  $updelay          = undef,
  $lacp_rate        = undef,
  $primary          = undef,
  $primary_reselect = undef,
  $xmit_hash_policy = undef,
) {

  $raw_bond_opts = {
    'bond-slaves'    => join($slaves, ' '),
    'bond-mode'      => $mode,
    'bond-miimon'    => $miimon,
    'bond-downdelay' => $downdelay,
    'bond-updelay'   => $updelay,
    'bond-lacp-rate' => $lacp_rate,
    'bond-primary'   => $primary,
    'bond-primary-reselect' => $primary_reselect,
    'bond-xmit-hash-policy' => $xmit_hash_policy,
  }

  $bond_opts = compact_hash($raw_bond_opts)

  $options_real = merge($options, $bond_opts)

  network_config { $name:
    ensure    => $ensure,
    ipaddress => $ipaddress,
    netmask   => $netmask,
    family    => $family,
    method    => $method,
    onboot    => $onboot,
    options   => $options_real,
  }

  network_config { $slaves:
    ensure      => absent,
    reconfigure => true,
    before      => Network_config[$name],
  }
}
