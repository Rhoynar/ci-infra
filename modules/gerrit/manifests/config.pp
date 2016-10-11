# Define gerrit::config
#
# set git config attributes
#
define gerrit::config(
  $value,
  $ensure = present,
  $file   = "${gerrit::target}/etc/gerrit.config"
){

  if type($value) == 'array' {
    # Check if the existing value in the config is set to exactly the right
    # combination of characters.  We do this by using a gross perl one-liner to
    # compare stdout from git-config with what puppet thinks should be the
    # output.  If it's not set to that, then we clear the value and notify the
    # Exec below to set all the values in one shot.  We allow an exit code of 5
    # from this check, since that just means that the value was already unset
    # and we can't make it more empty.
    $expected_output = join($value, '\n')
    $compare = "perl -e '\$/=1; \$x=<STDIN>; exit(\$x eq \"${expected_output}\\n\" ? 0 : 1)'"
    exec { "config_${name}_empty":
      command => "git config -f ${file} --unset-all \"${name}\"",
      unless  => "git config -f ${file} --get-all \"${name}\" | ${compare}",
      path    => $::path,
      require => Exec['install_gerrit'],
      returns => [0, 5],
    }

    # We want to run all these commands together because we can't use puppet
    # require to enforce ordering and the check on the empty exec assumes that
    # the values are in a specific order.
    $command = "git config -f ${file} --add \"${name}\" '"
    $prefixed_commands = prefix($value, $command)
    $suffixed_commands = suffix($prefixed_commands, "'")
    $all_commands = join($suffixed_commands, '; ')
    exec { "config_${name}":
      command     => $all_commands,
      path        => $::path,
      refreshonly => true,
      subscribe   => Exec["config_${name}_empty"],
    }
  } else {
    exec {
      "config_${name}":
        command => "git config -f ${file} \"${name}\" \'${value}\'",
        unless  => "test \"$(git config -f ${file} \"${name}\")\" = \'${value}\'",
        path    => $::path,
        require => Exec['install_gerrit'],
    }

  }

  if $gerrit::manage_service {
    Exec["config_${name}"] ~> Exec['reload_gerrit']
  }

}
