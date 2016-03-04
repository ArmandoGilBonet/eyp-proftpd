require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'proftpd': }

    	proftpd::user { 'example':
    		#Vm90YUp1bnRzUGVsU2kK
    		password => '$6$xkGStxTM$TyrthDmlYzXcVsOfNGS1bHUZvddVZImqxNXWGljw2rvijw3yeeA/N9eatMqou003uIb8k8kqWUtf7Ua24aqis0',
    		home => '/tmp/example',
    	}

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it "sleep 10 to make sure proftpd is started" do
      expect(shell("sleep 10").exit_code).to be_zero
    end

    describe port(21) do
      it { should be_listening }
    end

    describe package($packagename) do
      it { is_expected.to be_installed }
    end

    describe service($servicename) do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

  end

end
