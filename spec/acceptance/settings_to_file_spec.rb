require 'spec_helper_acceptance'

describe 'augeas_base::settings_to_file' do
  let(:manifest) {
    <<-EOS
    class { '::augeas_base':
      default_lens => 'Sshd.lns'
    }->
    augeas_base::settings_to_file { '/etc/ssh/sshd_config_test':
      settings => {
        'Port'    => '23'
      },
    }
    EOS
  }

  it 'should run without errors' do
    expect(apply_manifest(manifest, :catch_failures => true, :trace => true, :debug => true).exit_code).to eq(2)
  end

  it 'should re-run without changes' do
    expect(apply_manifest(manifest, :catch_changes => true, :trace => true, :debug => true).exit_code).to be_zero
  end

end
