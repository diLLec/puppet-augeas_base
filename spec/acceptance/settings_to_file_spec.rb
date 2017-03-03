require 'spec_helper_acceptance'

describe 'augeas_base::settings_to_file' do
  testfile_root = '/root/augeas_base_testfiles'

  context 'create and check sshd_config_test' do
    config_file = "#{testfile_root}/sshd_config_test"
    manifest =
    <<-EOS
    file {'#{testfile_root}':
      ensure => directory
    }->
    class { '::augeas_base':
      default_lens => 'Sshd.lns'
    }->
    augeas_base::settings_to_file { '#{config_file}':
      settings => {
        'Port'    => '23'
      },
    }
    EOS

    run_manifest manifest

    describe file(config_file) do
      it { should exist }
      its(:content) { should match %r{Port 23} }
    end
  end
  context 'create and check puppet_test.conf' do
    config_file = "#{testfile_root}/puppet_test.conf"
    manifest =
      <<-EOS
      file {'#{testfile_root}':
        ensure => directory
      }->
      augeas_base::settings_to_file { '#{config_file}':
        settings => {
          'main/certname' => 'agent01.example.com',
          'main/server'   => 'master.example.com',
          'agent/report'  => 'true',
          'master/dns_alt_names' => 'master,master.example.com,puppet,puppet.example.com'
        },
      }
      EOS

    run_manifest manifest

    describe file(config_file) do
      it { should exist }
      its(:content) { should match %r{report=true} }
      its(:content) { should match %r{[main]} }
      its(:content) { should match %r{dns_alt_names=master,master.example.com,puppet,puppet.example.com} }
    end
  end
end

