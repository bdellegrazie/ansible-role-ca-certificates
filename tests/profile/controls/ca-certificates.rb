control 'ca-certificates' do
  title 'CA Certificates'
  impact 1.0
  desc '
    Ensure CA Certificate integration is enabled in the OS
  '

  describe package('ca-certificates') do
    it { should be_installed }
  end

  print "os.release=#{os.release}"

  if os.redhat? && os.release < "7"
    describe command("/usr/bin/update-ca-trust check") do
      its('exit') { should eq 0 }
      its('stdout') { should match (/PEM.*Status.*ENABLED/) }
    end
  end
end
