require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'unbound::local_zones', :type => 'define' do
  let(:title) { 'test.com' }
  context "with default_values" do
    let(:params) {
      {
        :values => { 'test.com' => {
          'test.com'        => '127.1.0.1',
          'test2.test.com'  => [ '127.1.0.2', '127.1.0.3' ]
        } }
      }
    }
    it { should contain_unbound__local_zone(title).with(
      :values => {
        'test.com'        => '127.1.0.1',
        'test2.test.com'  => [ '127.1.0.2', '127.1.0.3' ]
      }
    )}
  end
end
