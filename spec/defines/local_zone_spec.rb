require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'unbound::local_zone', :type => 'define' do
  let(:title) { 'test.com' }
  context "with default_values" do
    let(:params) {
      {
        :values => {
          'test.com'        => '127.1.0.1',
          'test2.test.com'  => [ '127.1.0.2', '127.1.0.3' ]
        }
      }
    }
    it { should contain_unbound__conf('test.com') }
    it { should contain_unbound__conf('test.com').with_content('local-zone: "test.com." redirect

local-data: "test.com. IN A 127.1.0.1"
local-data: "test2.test.com. IN A 127.1.0.2"
local-data: "test2.test.com. IN A 127.1.0.3"
')}
  end
end
