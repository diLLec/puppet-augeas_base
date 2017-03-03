require 'spec_helper_acceptance'

describe 'augeas_base::dirsettings_to_file' do
  testfile_root = '/root/augeas_base_testfiles'

  context 'augeas_base::dirsettings_to_file - oversight test' do
    config_file = "#{testfile_root}/sshd_config_test"
    specific_user = 'asterisk'

    manifest =
    <<-EOS
    file {'#{testfile_root}':
      ensure => directory
    }->
    class { '::augeas_base':
      default_lens => 'Sshd.lns',
      default_owner => '#{specific_user}'
    }->
    augeas_base::dirsettings_to_file { '#{config_file}':
      dirsettings => {
        'ChrootDirectory' => '/tmp/myssh'
      },
      filesettings => {
        'HostKey' => '#{testfile_root}/ssh_host_key',
        'HostCertificate' => '#{testfile_root}/cert.pem',
        'PidFile' => '#{testfile_root}/mysshd.pid'
      },
    }
    EOS

    run_manifest manifest

    describe file(config_file) do
      it { should exist }
      its(:content) { should match %r{ChrootDirectory /tmp/myssh} }
      its(:content) { should match %r{HostKey #{testfile_root}/ssh_host_key} }
    end

    describe file('/tmp/myssh') do
      it { should exist }
      it { should be_owned_by specific_user}
    end

    %W(#{testfile_root}/ssh_host_key #{testfile_root}/cert.pem #{testfile_root}/mysshd.pid).each do |filename|
      describe file(filename) do
        it { should exist }
        it { should be_owned_by specific_user}
      end
    end

  end
end

