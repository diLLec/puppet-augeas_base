
if ENV.has_key? 'LOCAL_TEST'
  require 'serverspec'
  set :backend, :exec
else
  require 'spec_helper_acceptance'
end

describe 'augeas_base::settings_to_file' do

  config_file = '/etc/ssh/sshd_config_test'

  let(:manifest) {
    <<-EOS
    class { '::augeas_base':
      default_lens => 'Sshd.lns'
    }->
    augeas_base::settings_to_file { '#{config_file}':
      settings => {
        'Port'    => '23'
      },
    }
    EOS
  }

  if ENV.has_key? 'LOCAL_TEST'
    print 'Notice: Skipping apply_manifest changes, due to local test. Please run puppet apply manually.'
  else
    # with local tests, we can't use beaker function like apply_manifest

    it 'should run without errors' do
      expect(apply_manifest(manifest, :catch_failures => true, :trace => true, :debug => true).exit_code).to eq(2)
    end

    it 'should re-run without changes' do
      expect(apply_manifest(manifest, :catch_changes => true, :trace => true, :debug => true).exit_code).to be_zero
    end
  end

  describe file(config_file) do
    it { should exist }
    its(:content) { should match /Port 23/ }
  end

end
