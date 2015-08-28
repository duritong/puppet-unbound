require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'unbound::forward_zones', :type => 'define' do
  let(:title) { 'test.com' }
  context "with default_values" do
    let(:params) {
      {
        :values => { 'test.com' => [ '127.1.0.2', '127.1.0.3' ] }
      }
    }
    it { should contain_unbound__forward_zone(title).with(
      :addrs => [ '127.1.0.2', '127.1.0.3' ]
    )}
  end
end

