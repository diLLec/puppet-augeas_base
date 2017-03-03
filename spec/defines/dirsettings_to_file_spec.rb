require 'spec_helper'

describe 'augeas_base::dirsettings_to_file' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let :facts do
        facts
      end

      testfile_root = '/root/augeas_base_testfiles'
      relevant_file = "#{testfile_root}/sshd_config_test"

      let(:title) { relevant_file }
      let(:params) do
        {
            dirsettings: {
                'ChrootDirectory' => '/tmp/myssh'
            },
            filesettings: {
                'HostKey' => "#{testfile_root}/ssh_host_key",
                'HostCertificate' => "#{testfile_root}/cert.pem",
                'PidFile' => "#{testfile_root}/mysshd.pid"
            }
        }
      end
      context 'augeas_base::dirsettings_to_file - simple' do
        it { is_expected.to compile }
        it { is_expected.to contain_augeas_base__dirsettings_to_file(relevant_file) }
        it { is_expected.to contain_augeas_base__settings_to_file(relevant_file) }
        it { is_expected.to contain_file("#{testfile_root}/ssh_host_key").with_ensure('file') }
        it { is_expected.to contain_file("#{testfile_root}/cert.pem").with_ensure('file') }
        it { is_expected.to contain_file("#{testfile_root}/mysshd.pid").with_ensure('file') }
        it { is_expected.to contain_file('/tmp/myssh').with_ensure('directory') }
      end

      context 'augeas_base::dirsettings_to_file - with global default_owner' do
        specific_owner = 'asterisk'
        let(:pre_condition) {
          <<-EOS
          class { 'augeas_base':
            default_owner => '#{specific_owner}',
          }
          EOS
        }

        it { is_expected.to compile }
        it { is_expected.to contain_augeas_base__dirsettings_to_file(relevant_file) }
        it { is_expected.to contain_augeas_base__settings_to_file(relevant_file) }

        %W(#{testfile_root}/ssh_host_key #{testfile_root}/cert.pem #{testfile_root}/mysshd.pid).each do |filename|
          it { is_expected.to contain_file(filename).with_ensure('file').with_owner(specific_owner).with_group(specific_owner) }
        end

        it { is_expected.to contain_file('/tmp/myssh').with_ensure('directory').with_owner(specific_owner).with_group(specific_owner) }
      end
    end
  end
end
