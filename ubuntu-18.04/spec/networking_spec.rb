describe file('/etc/netplan/01-netcfg.yaml') do
  its(:content) { should match <<~FILE
    network:
      version: 2
      ethernets:
        eth0:
          dhcp4: true
  FILE
}
end

describe file('/etc/network/interfaces') do
  it { should contain 'eth0' }
end

describe file('/etc/default/grub') do
  it { should contain 'GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 ' }
end
