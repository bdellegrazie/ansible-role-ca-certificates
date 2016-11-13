require 'spec_helper'

Serverspec.describe 'ca-certificates' do

  describe(package('ca-certificates')) do
    it { should be_installed }
  end

  describe "x509 example certificate" do
    let(:ca_certificates_dir) {
      case os[:family]
      when 'redhat'
        return '/etc/pki/ca-trust/source/anchors'
      when 'debian'
        return '/usr/local/share/ca-certificates'
      when 'ubuntu'
        return '/usr/local/share/ca-certificates'
      end
    }

    subject! { x509_certificate("#{ca_certificates_dir}/www.example.com.crt") }

    it { should be_certificate }
    its(:subject) { should eq('/C=UK/ST=England/L=London/O=Example Org/OU=Org/CN=www.example.com') }
  end

  describe command("/usr/bin/update-ca-trust check"), :sudo => false, :if => os[:family] == 'redhat' do
    let(:disable_sudo) { true }
    its(:stdout) { should match /PEM.*Status.*ENABLED/ }
  end
  # Debian's ca-certificates is enabled if installed
end
