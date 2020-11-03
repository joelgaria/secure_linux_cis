# Created by Joel Garia -> joel.garia93@gmail.com

# Install required services
class { 'secure_linux_cis_hardened::services':
    tag    => ['cis_services']
}
# The principal secure linux cis
class {'::secure_linux_cis':
   time_servers  => ['0.de.pool.ntp.org', '1.de.pool.ntp.org','2.de.pool.ntp.org', '3.de.pool.ntp.org'],
   profile_type  => 'server',
   schedule => 'harden_schedule',
   enforcement_level => "1",
   allow_users   => ['ec2-user','ssm-user'],
   ipv6_enabled => true
} 
# Add firewall rules 
class { 'secure_linux_cis_hardened::firewall_rules':
    tag    => ['cis_firewall_rule']
}
# First vulnerability fixed (find with AWS Inspector)
class { 'secure_linux_cis_hardened::delete_etc_motd':
    tag    => ['delete_etc_motd']
}
# Second vulnerability fixed (find with AWS Inspector)
class { 'secure_linux_cis_hardened::fstab':
    tag    => ['fstab']
}
