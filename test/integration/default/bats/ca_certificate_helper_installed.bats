#!/usr/bin/env bats

@test "CA certificate helper enabled (RedHat Family)" {
  [ -e /etc/redhat-release ] || skip "not RedHat Family"
  run update-ca-trust check
  [ "$status" -eq 0 ]
  [[ ${lines[0]} =~ ENABLED ]] || fail
}

@test "CA certificate helper enabled (Debian Family)" {
  [ -e /etc/debian_version ] || skip "not Debian Family"
  run update-ca-certificates --help
  [ "$status" -eq 0 ]
}
