if ENV.has_key? 'LOCAL_TEST'
  require 'serverspec'
  set :backend, :exec
else
  require 'beaker-rspec'

  install_puppet_agent_on hosts, {}

  hosts.each do |host|
    on host, 'puppet cert generate $(facter fqdn)'
  end

  RSpec.configure do |c|
    # Project root
    module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    module_name = module_root.split('-').last

    # Readable test descriptions
    c.formatter = :documentation

    # Configure all nodes in nodeset
    c.before :suite do
      # Install module and dependencies
      puppet_module_install(:source => module_root, :module_name => module_name)

      hosts.each do |host|
        on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      end
    end
  end
end


def run_manifest (manifest)
  if ENV.has_key? 'LOCAL_TEST'
    print 'Notice: Skipping apply_manifest changes, due to local test. Please run puppet apply manually with the manifest above.\n'
  else
    # with local tests, we can't use beaker function like apply_manifest

    it 'should run without errors' do
      expect(apply_manifest(manifest, :catch_failures => true).exit_code).to eq(2)
    end

    it 'should re-run without changes' do
      expect(apply_manifest(manifest, :catch_changes => true).exit_code).to be_zero
    end
  end
end
