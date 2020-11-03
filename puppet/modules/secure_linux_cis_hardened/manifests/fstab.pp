# Created by Joel Garia -> joel.garia93@gmail.com
# Second vulnerability fixed (find with AWS Inspector)

class secure_linux_cis_hardened::fstab (){
  $mount_tmp = '/tmp'
  $options_tmp = 'defaults,rw,nosuid,nodev,noexec,relatime'

  mount { $mount_tmp:
    ensure  => mounted,
    name    => $mount_tmp,
    target  => '/etc/fstab',
    fstype  => 'tmpfs',
    device  => 'tmpfs',
    options => $options_tmp,
    pass    => '0',
    dump    => '0'
  }
}
