# == Define: acli::task
#
# This define generates cron entries to create scheduled jira issues
#
#
# === Parameters
#
# [*project*]
#   String. Name of Jira project
#   Required
#
# [*summary*]
#   String.  Summary of the issue
#   Required
#
# [*assignee*]
#   String.  Username to assign the issue to
#
# [*description*]
#   String.  Description field of the issue
#
# [*labels*]
#   String.  Labels to apply to the issue (space seperated)
#
# [*parent*]
#   String.  Parent issue
#
# [*type*]
#   String.  Issue type
#
# [*monthday*]
#   Cron value of the monthday field
#
# [*month*]
#   Cron value of the month field
#
# [*hour*]
#   Cron value of the hour field
#
# [*minute*]
#   Cron value of the minute field
#
# [*weekday*]
#   Cron value of the weekday field
#
#
# === Examples
#
# acli::jira { 'test_backups':
#   project     => 'admin',
#   summary     => 'Quarterly production backups test',
#   description => 'Production database backups need to be restored and verified with the verification scripts',
#   month       => '1,4,7,10'
# }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
define acli::jira (
  $project,
  $summary,
  $assignee     = '',
  $description  = '',
  $labels       = '',
  $parent       = '',
  $type         = 'task',
  $monthday     = 1,
  $month        = 1,
  $hour         = 0,
  $minute       = 1,
  $weekday      = '*',
  $ensure       = 'present',
) {

  if $labels != '' {
    $label_switch = " --labels '${labels}'"
  } else {
    $label_switch = ''
  }

  if $assignee != '' {
    $assignee_switch = " --assignee '${assignee}'"
  } else {
    $assignee_switch = ''
  }

  if $description != '' {
    $description_switch = " --description '${description}'"
  } else {
    $description_switch = ''
  }

  if $parent != '' {
    $parent_switch = " --parent '${parent}'"
  } else {
    $parent_switch = ''
  }

  cron { "jira_${name}":
    ensure   => $ensure,
    command  => "/opt/acli/atlassian.sh jira --action createIssue --project '${project}' --summary '${summary}' --type '${type}'${label_switch}${assignee_switch}${description_switch}${parent_switch}",
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,

  }

}
