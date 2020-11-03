# Created by Joel Garia -> joel.garia93@gmail.com
# First vulnerability fixed (find with AWS Inspector)

class secure_linux_cis_hardened::delete_etc_motd (){
  exec { 'delete_etc_motd':
        command     => "cat > /etc/motd",
        user        => "root",
        path        => ' :/usr/sbin:/bin:/usr/local/bin',
    }
}
