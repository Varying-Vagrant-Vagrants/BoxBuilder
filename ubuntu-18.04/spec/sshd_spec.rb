describe file('/etc/ssh/sshd_config') do
  it { should contain 'UseDNS no' }
  it { should contain 'GSSAPIAuthentication no' }
end
