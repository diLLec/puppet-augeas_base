require 'spec_helper_acceptance'

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

    it { run_manifest (manifest) }

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

    it { run_manifest (manifest) }

    describe file(config_file) do
      it { should exist }
      its(:content) { should match /report=true/ }
      its(:content) { should match /[main]/ }
      its(:content) { should match /dns_alt_names=master,master.example.com,puppet,puppet.example.com/ }
    end
  end
end

