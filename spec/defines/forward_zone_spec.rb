require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'unbound::forward_zone', :type => 'define' do
  context "without addrs" do
    let(:title) { 'test.com' }
    it { expect { should compile }.to raise_error(/requires addrs or hosts if it should be present/) }
  end
  context "with wrong first" do
    let(:title) { 'test.com' }
    let(:params) {
      {
        :addrs => [ '127.1.0.2', '127.1.0.3' ],
        :first => 'bla',
      }
    }
    it { expect { should compile }.to raise_error(/does not match \["\^yes\$", "\^no\$"\]/) }
  end
  context "with additions params" do
    let(:title) { 'test.com' }
    let(:params) {
      {
        :hosts => [ 'a.b', 'c.d' ],
        :addrs => [ '127.1.0.2', '127.1.0.3' ],
        :first => 'no',
      }
    }
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with(
      :owner    => 'root',
      :group    => 0,
      :mode     => '0640',
      :require  => 'Package[unbound]',
      :notify   => 'Service[unbound]'
    )}
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with_content('forward-zone:
  name: "test.com"
  forward-host: a.b
  forward-host: c.d
  forward-addr: 127.1.0.2
  forward-addr: 127.1.0.3
  forward-first: no
')}
  end
  context "with default_values" do
    let(:title) { 'test.com' }
    let(:params) {
      {
        :addrs => [ '127.1.0.2', '127.1.0.3' ]
      }
    }
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with(
      :owner    => 'root',
      :group    => 0,
      :mode     => '0640',
      :require  => 'Package[unbound]',
      :notify   => 'Service[unbound]'
    )}
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with_content('forward-zone:
  name: "test.com"
  forward-addr: 127.1.0.2
  forward-addr: 127.1.0.3
')}
  end
  context "with default forward" do
    let(:title) { 'default' }
    let(:params) {
      {
        :addrs => [ '127.1.0.2', '127.1.0.3' ]
      }
    }
    it { should contain_file("/etc/unbound/conf.d/default.conf").with(
      :owner    => 'root',
      :group    => 0,
      :mode     => '0640',
      :require  => 'Package[unbound]',
      :notify   => 'Service[unbound]'
    )}
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with_content('forward-zone:
  name: "."
  forward-addr: 127.1.0.2
  forward-addr: 127.1.0.3
')}
  end
  context "with absent" do
    let(:title) { 'foo.com' }
    let(:params) {
      {
        :ensure => 'absent'
      }
    }
    it { should contain_file("/etc/unbound/conf.d/foo.com.conf").with(
      :ensure   => 'absent',
      :require  => 'Package[unbound]',
      :notify   => 'Service[unbound]'
    )}
  end
  context "with default absent" do
    let(:title) { 'default' }
    let(:params) {
      {
        :ensure => 'absent'
      }
    }
    it { should contain_file("/etc/unbound/conf.d/default.conf").with(
      :ensure   => 'absent',
      :require  => 'Package[unbound]',
      :notify   => 'Service[unbound]'
    )}
  end
end
