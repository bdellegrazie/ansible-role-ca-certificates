control 'ca-cacert-org' do
  title 'CA cacert.org'
  impact 1.0
  desc '
    Ensure CA Certificate for cacert.org is installed into the operating system trust store
  '

  ca_certificates_local_dir = case os.family
    when 'redhat','fedora'
      '/etc/pki/ca-trust/source/anchors'
    when 'debian'
      '/usr/local/share/ca-certificates'
    when 'ubuntu'
      '/usr/local/share/ca-certificates'
  end

  ca_certificates_bundle = case os.family
    when 'redhat','fedora'
      '/etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt'
    when 'debian'
      '/etc/ssl/certs/ca-certificates.crt'
    when 'ubuntu'
      '/etc/ssl/certs/ca-certificates.crt'
  end

  describe x509_certificate("#{ca_certificates_local_dir}/cacert.org.crt") do
    it { should be_certificate }
    its('subject_dn') { should eq('/O=Root CA/OU=http://www.cacert.org/CN=CA Cert Signing Authority/emailAddress=support@cacert.org') }
    its('validity_in_days') { should be > 7 }
  end

  # The certificate must be in the trust store for this to work
  describe command("openssl verify -CAfile #{ca_certificates_bundle} #{ca_certificates_local_dir}/cacert.org.crt") do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/: OK$/) }
  end
end
