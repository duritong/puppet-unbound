require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'unbound::forward_zone', :type => 'define' do
  let(:pre_condition) {
    'include unbound'
  }
  let(:facts){
    {
      operatingsystem: 'CentOS',
      operatingsystemmajrelease: '7'
    }
  }
  context "without addrs" do
    let(:title) { 'test.com' }
    it { expect { should compile }.to raise_error(/requires addrs or hosts/) }
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
    it { should contain_unbound__conf(title) }
    it { should contain_unbound__conf(title).with_content('forward-zone:
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
    it { should contain_unbound__conf(title) }
    it { should contain_unbound__conf(title).with_content('forward-zone:
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
    it { should contain_unbound__conf('default') }
    it { should contain_unbound__conf('default').with_content('forward-zone:
  name: "."
  forward-addr: 127.1.0.2
  forward-addr: 127.1.0.3
')}
  end
  context "with default forward using a ." do
    let(:title) { '.' }
    let(:params) {
      {
        :addrs => [ '127.1.0.2', '127.1.0.3' ]
      }
    }
    it { should contain_unbound__conf('default') }
    it { should contain_unbound__conf('default').with_content('forward-zone:
  name: "."
  forward-addr: 127.1.0.2
  forward-addr: 127.1.0.3
')}
  end
end
