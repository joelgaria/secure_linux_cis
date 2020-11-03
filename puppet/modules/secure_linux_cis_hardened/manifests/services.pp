# Created by Joel Garia -> joel.garia93@gmail.com
# Install required services

class secure_linux_cis_hardened::services (){
  package { 'iptables-services.x86_64':
    ensure => 'installed',
  }
  exec { 'service-iptables-start':
        command     => "systemctl start iptables",
        user        => "root",
        path        => '/sbin:/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    }
  exec { 'service-iptables-enable':
        command     => "systemctl enable iptables",
        user        => "root",
        path        => '/sbin:/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    }
}
   
