describe file('/etc/sudoers') do
  it { should contain "Defaults\texempt_group=sudo" }
end

describe file('/etc/sudoers.d/99_vagrant') do
  its(:content) { should match 'vagrant ALL=(ALL) NOPASSWD:ALL\n' }
end