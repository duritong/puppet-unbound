require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'unbound::conf', :type => 'define' do
  context "without content" do
    let(:title) { 'test.com' }
    it { expect { should compile }.to raise_error(/Must define content/) }
  end
  context "by default" do
    let(:title) { 'test.com' }
    let(:params) {
      {
        :content => 'content'
      }
    }
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with(
      :owner    => 'root',
      :group    => 0,
      :mode     => '0640',
      :require  => 'Package[unbound]',
      :notify   => 'Service[unbound]'
    )}
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with_content('content') }
    it { should contain_file_line("#{title}_unbound_include").with(
      :ensure => 'present',
      :line   => "include: /etc/unbound/conf.d/#{title}.conf",
      :path   => '/etc/unbound/conf.d/includes.conf',
      :notify => 'Service[unbound]',
    )}
  end
  context "with default absent" do
    let(:title) { 'default' }
    let(:params) {
      {
        :ensure => 'absent'
      }
    }
    it { should contain_file("/etc/unbound/conf.d/#{title}.conf").with(
      :ensure  => 'absent',
      :owner   => 'root',
      :group   => 0,
      :mode    => '0640',
      :require => 'Package[unbound]',
      :notify  => 'Service[unbound]'
    )}
    it { should contain_file_line("#{title}_unbound_include").with(
      :ensure => 'absent',
      :line   => "Include: /etc/unbound/conf.d/#{title}.conf",
      :path   => '/etc/unbound/conf.d/includes.conf',
      :notify => 'Service[unbound]',
    )}
  end
end
