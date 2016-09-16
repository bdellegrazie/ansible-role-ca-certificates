ca-certificates
===============

This role manages ca-certificates on Debian / RedHat family OS, it uses the OS native certificate management tool to do this. The OS tools usually manage OpenJDK cacerts file too if the appropriate package is installed

[![Build Status](https://travis-ci.org/bdellegrazie/ansible-role-ca-certificates.svg?branch=master)](https://travis-ci.org/bdellegrazie/ansible-role-ca-certificates)

Role Variables
--------------

    ca_certificates_handler: "notify" this variable triggers update of OS of CA certificates
    ca_certificates_local_dir: the directory to copy CA Certificates to, set in vars
    ca_certificates_trusted: List of name/pem certificate pairs to copy to ca_certificates_local_dir

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { ca_certificates }

License
-------

GPLv3

Author Information
------------------

https://github.com/bdellegrazie/ansible-role-ca-certificates
