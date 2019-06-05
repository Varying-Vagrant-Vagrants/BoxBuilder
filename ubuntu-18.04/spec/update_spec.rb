describe file('/etc/update-manager/release-upgrades') do
  it { should contain 'Prompt=never' }
end

describe service('apt-daily.timer') do
  it { should_not be_running }
  it { should_not be_enabled }
end

describe service('apt-daily-upgrade.timer') do
  it { should_not be_running }
  it { should_not be_enabled }
end

describe file('/etc/apt/apt.conf.d/10periodic') do
  its(:content) { should match <<~FILE
    APT::Periodic::Enable "0";
    APT::Periodic::Update-Package-Lists "0";
    APT::Periodic::Download-Upgradeable-Packages "0";
    APT::Periodic::AutocleanInterval "0";
    APT::Periodic::Unattended-Upgrade "0";
  FILE
}
end

describe file('/var/log/unattended-upgrades') do
  it { should_not exist }
end

describe package('unattended-upgrades') do
  it { should_not be_installed }
end