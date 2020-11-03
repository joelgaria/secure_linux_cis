# Created by Joel Garia -> joel.garia93@gmail.com
# Add firewall rules 

class secure_linux_cis_hardened::firewall_rules (){
  firewall { '010 httpd http port':
    chain  => 'INPUT',
    dport  => 80,
    state  => 'NEW',
    action => 'accept',
    proto  => 'tcp',
    tag    => 'cis_firewall_rule'
  }
}
