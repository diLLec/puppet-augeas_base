
if ENV.has_key? 'LOCAL_TEST'
  require 'serverspec'
  set :backend, :exec
else
  require 'spec_helper_acceptance'
end

describe 'augeas_base::settings_to_file' do
  context 'create and check /etc/ssh/sshd_config_test' do
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
      print 'Notice: Skipping apply_manifest changes, due to local test. Please run puppet apply manually with the manifest above.\n'
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
  context 'create and check /etc/puppetlabs/puppet/puppet_test.conf' do
    config_file = '/etc/puppetlabs/puppet/puppet_test.conf'
    let(:manifest) {
      <<-EOS
      augeas_base::settings_to_file { '#{config_file}':
        settings => {
          'main/certname' => 'agent01.example.com',
          'main/server'   => 'master.example.com',
          'agent/report'  => 'true',
          'master/dns_alt_names' => 'master,master.example.com,puppet,puppet.example.com'
        },
      }
      EOS
    }

    if ENV.has_key? 'LOCAL_TEST'
      print 'Notice: Skipping apply_manifest changes, due to local test. Please run puppet apply manually with the manifest above.\n'
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
      its(:content) { should match /report=true/ }
      its(:content) { should match /[main]/ }
      its(:content) { should match /dns_alt_names=master,master.example.com,puppet,puppet.example.com/ }
    end
  end
end

