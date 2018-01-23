require 'spec_helper'

Serverspec.describe 'ca-certificates' do

  describe(package('ca-certificates')) do
    it { should be_installed }
  end

  describe command("/usr/bin/update-ca-trust check"), :if => (os[:family] == 'redhat' and host_inventory[:platform_version] < '7.0') do
    let(:disable_sudo) { true }
    its(:stdout) { should match /PEM.*Status.*ENABLED/ }
  end

  describe "x509 example certificate" do
    let(:ca_certificates_local_dir) {
      case os[:family]
      when 'redhat','fedora'
        '/etc/pki/ca-trust/source/anchors'
      when 'debian'
        '/usr/local/share/ca-certificates'
      when 'ubuntu'
        '/usr/local/share/ca-certificates'
      end
    }
    let(:ca_certificates_bundle) {
      case os[:family]
      when 'redhat','fedora'
        '/etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt'
      when 'debian'
        '/etc/ssl/certs/ca-certificates.crt'
      when 'ubuntu'
        '/etc/ssl/certs/ca-certificates.crt'
      end
    }

    subject! { x509_certificate("#{ca_certificates_local_dir}/www.example.com.crt") }

    it { should be_certificate }
    its(:subject) { should eq('/C=UK/ST=England/L=London/O=Example Org/OU=Org/CN=www.example.com/emailAddress=brett.dellegrazie@gmail.com') }

    describe "verify certificates" do
      it "should openssl verify certificate" do
        expect( command("openssl verify -CAfile #{ca_certificates_bundle} #{ca_certificates_local_dir}/www.example.com.crt").stdout).to match /: OK$/
      end
    end
  end

  # RedHat 7+ doesn't have 'check'
  # Debian's ca-certificates is enabled if installed
end
